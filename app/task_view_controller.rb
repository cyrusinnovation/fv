class TaskViewController < UIViewController
  include Notifications
  
  TaskHeight = 50
  TextEntryHeight = 50
  
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    scroll_view_frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - TextEntryHeight)
    @scroll_view = UIScrollView.alloc.initWithFrame(scroll_view_frame)
    view.addSubview(@scroll_view)
    @scroll_view.delegate = self
    
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
    
    drawTasks
  end
  
  def handleTaskAdded(notification)
    #For now, we just redraw everything
    redraw_tasks
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
    @scroll_view.subviews.each do |task_view|
      task_view.removeFromSuperview
    end
    drawTasks
  end
  
  def scrollViewDidScroll(scrollView)
    # As currently designed, this is a display memory hog.
    # Here is where we would allocate or deallocate views based on the contentOffset
    adjust_selected
  end 

  def adjust_selected
    yoffset = @scroll_view.contentOffset.y
    
    @selected_indexes_for_adjust.each do |index|
      y = [yoffset, TaskHeight * index].max
      @task_views_for_adjust[index].frame = CGRectMake(0,y,@scroll_view.frame.size.width,TaskHeight)
    end    
  end
  
  def drawTasks

    task_y = Hash.new
    TaskStore.shared.tasks.each_index do |index|
      task = TaskStore.shared.tasks[index]
      task_y[task.objectID] = TaskHeight * index
    end

    selected_indexes = []
    TaskStore.shared.tasks.each_index do |index|
      task = TaskStore.shared.tasks[index]
      if task.dotted?
        selected_indexes << index
      end
    end

    task_views = []
    TaskStore.shared.tasks.each_index do |index|
      task = TaskStore.shared.tasks[index]
      task_frame = CGRectMake(0, task_y[task.objectID], @scroll_view.frame.size.width, TaskHeight)
      subview = TaskView.alloc.initWithFrame(task_frame, task:task, position:index)
      task_views << subview
      @scroll_view.addSubview(subview)
    end

    
    selected_indexes.each do |index|
      @scroll_view.bringSubviewToFront(task_views[index])
    end
    
    @scroll_view.contentSize = CGSizeMake(@scroll_view.frame.size.width, TaskStore.shared.tasks.size * TaskHeight)
    
    yoffset = @scroll_view.contentOffset.y
    
    selected_indexes.each do |index|
      y = [yoffset, TaskHeight * index].max
      task_views[index].frame = CGRectMake(0,y,@scroll_view.frame.size.width,TaskHeight)
    end    

    collect_adjust_data

  end
  
  def collect_adjust_data
    @task_views_for_adjust = []
    @scroll_view.subviews.each do |subview|
      @task_views_for_adjust[subview.position] = subview
    end

    @selected_indexes_for_adjust = []
    TaskStore.shared.tasks.each_index do |index|
      task = TaskStore.shared.tasks[index]
      if task.dotted?
        @selected_indexes_for_adjust << index
      end
    end
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
