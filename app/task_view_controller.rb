class TaskViewController < UIViewController
  include Notifications
  
  TaskHeight = 50
  TextEntryHeight = 50
  
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    scroll_view_frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - TextEntryHeight)
    @scrollView = UIScrollView.alloc.initWithFrame(scroll_view_frame)
    view.addSubview(@scrollView)
    @scrollView.delegate = self
    
    text_field_frame = CGRectMake(0, view.frame.size.height - TextEntryHeight, view.frame.size.width, TextEntryHeight)
    @text_field = UITextField.alloc.initWithFrame(text_field_frame)
    @text_field.delegate = self
    @text_field.backgroundColor = UIColor.redColor
    view.addSubview(@text_field)
    
    observe(TaskAddedNotification, 'handleTaskAdded')
    observe(TaskChangedNotification, 'handleTaskChanged')
    observe(TaskRemovedNotification, 'handleTaskRemoved')
    
    # Make the helper a field so that it isn't garbage collected.
    @textfield_visibility_helper = TextFieldVisibilityHelper.new(@text_field)
    
    addTasks
  end
  
  def handleTaskAdded(notification)
    redraw_tasks
    @scrollView.scrollRectToVisible(@task_views.last.frame, animated:true)
  end
  
  def handleTaskChanged(notification)
    #For now, we just redraw everything
    redraw_tasks
  end
  
  def handleTaskRemoved(notification)
    #For now, we just redraw everything
    redraw_tasks
  end
  
  def redraw_tasks
    @task_views.each do |task_view|
      task_view.removeFromSuperview
    end
    addTasks
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
    
    @scrollView.contentSize = CGSizeMake(@scrollView.frame.size.width, TaskStore.shared.tasks.size * TaskHeight)
  end
  
  def task_view(index, task)
    task_frame = CGRectMake(0, TaskHeight * index, @scrollView.frame.size.width, TaskHeight)
    TaskView.alloc.initWithFrame(task_frame, task:task)
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
    true
  end

end
