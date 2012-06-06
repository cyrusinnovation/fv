class TaskViewController < UIViewController
  TaskHeight = 50
  TextEntryHeight = 50
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @scrollView = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    view.addSubview(@scrollView)
    @scrollView.contentSize = CGSizeMake(@scrollView.frame.size.width, TaskStore.shared.tasks.size * TaskHeight)
    @scrollView.delegate = self
    drawTasks
    # drawTextBox
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
  

  def drawTasks
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
  #   text_box_frame = CGRectMake(0, @task_views.size * TaskHeight, view.frame.size.width, TaskHeight)
  #   @text_box = UITextField.alloc.initWithFrame(text_box_frame)
  #   @text_box.delegate = self
  #   @text_box.backgroundColor = UIColor.redColor
  #   view.addSubview(@text_box)
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
    puts textField.text
    true
  end

  
  
  
end