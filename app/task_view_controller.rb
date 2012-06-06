class TaskViewController < UIViewController
  TaskHeight = 50
  TextEntryHeight = 50
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    scroll_view_frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - TextEntryHeight)
    @scrollView = UIScrollView.alloc.initWithFrame(scroll_view_frame)
    view.addSubview(@scrollView)
    @scrollView.contentSize = CGSizeMake(@scrollView.frame.size.width, TaskStore.shared.tasks.size * TaskHeight)
    @scrollView.delegate = self
    
    text_field_frame = CGRectMake(0, view.frame.size.height - TextEntryHeight, view.frame.size.width, TextEntryHeight)
    @text_field = UITextField.alloc.initWithFrame(text_field_frame)
    @text_field.delegate = self
    @text_field.backgroundColor = UIColor.redColor
    view.addSubview(@text_field)
    
    # Register for keyboard notifications so that we can move the text input box.
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardDidShow:', name:UIKeyboardDidShowNotification, object:nil)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardDidHide:', name:UIKeyboardDidHideNotification, object:nil)
    
    addTasks
  end
  
  def keyboardDidShow(notification)
    keyboardSize = notification.userInfo.objectForKey(UIKeyboardBoundsUserInfoKey).CGRectValue.size
    new_text_field_frame = CGRectMake(0, view.frame.size.height - (TextEntryHeight + keyboardSize.height), view.frame.size.width, TextEntryHeight)
    @text_field.frame = new_text_field_frame
  end
  
  def keyboardDidHide(notification)
    new_text_field_frame = CGRectMake(0, view.frame.size.height - TextEntryHeight, view.frame.size.width, TextEntryHeight)
    @text_field.frame = new_text_field_frame
  end
  
  def scrollViewDidScroll(scrollView)
    # As currently designed, this is a display memory hog.
    # Here is where we would allocate or deallocate views based on the contentOffset
    yoffset = scrollView.contentOffset.y
    
    @selected_indexes.each do |index|
      y = [yoffset, TaskHeight * index].max
      @task_views[index].frame = CGRectMake(0,y,scrollView.frame.size.width,TaskHeight)
    end    
    
  end
  

  def addTasks
    @task_views = []
    @selected_indexes = []
    TaskStore.shared.tasks.each_index do |index|
      task = TaskStore.shared.tasks[index]
      subview = task_view(index, task)
      @task_views << subview
      @scrollView.addSubview(subview)
      if task.dotted?
        @selected_indexes << index
      end
    end
    
    @selected_indexes.each do |index|
      @scrollView.bringSubviewToFront(@task_views[index])
    end
  end
  
  # def drawTextBox
  #   # draw text box on bottom of scrollview
  # end
  
  def task_view(index, task)
    task_frame = CGRectMake(0, TaskHeight * index, @scrollView.frame.size.width, TaskHeight)
    task_view = UIView.alloc.initWithFrame(task_frame)
    task_label = UILabel.alloc.initWithFrame(CGRectMake(0,0, task_view.frame.size.width, task_view.frame.size.height))
    task_label.text = task.text
    task_view.addSubview(task_label)
    if task.dotted?
      task_label.backgroundColor = UIColor.grayColor
    end
    task_view
  end
  
  # Defined for UITextFieldDelegate
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    textField.text = nil
    true
  end
  
  def textFieldDidEndEditing(textField)
    TaskStore.shared.add_task do |task|
      task.date_moved = NSDate.date
      task.text = textField.text
      task.dotted = false
    end
    
    task = TaskStore.shared.tasks.last
    
    @scrollView.contentSize = CGSizeMake(@scrollView.frame.size.width, TaskStore.shared.tasks.size * TaskHeight)
    @scrollView.addSubview(task_view(TaskStore.shared.tasks.size - 1, task))
    true
  end

  
  
  
end