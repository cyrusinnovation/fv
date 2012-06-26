class TaskViewController < UIViewController
  include Notifications
  
  TextEntryHeight = 40
  
  def initWithStore(task_store)
    if init
      @task_store = task_store
    end
    self
  end
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    
    scroll_view_frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
    @scroll_view = TaskListView.alloc.initWithFrame(scroll_view_frame, taskStore:@task_store)
    view.addSubview(@scroll_view)
    @scroll_view.delegate = self

    add_button_view

    # Observe model changes.
    observe(TaskAddedNotification, action:'handleTaskAdded')
    observe(TaskChangedNotification, action:'handleTaskChanged')
    observe(TaskRemovedNotification, action:'handleTaskRemoved')
    observe(TaskPausedNotification, action:'handleTaskPaused')
    
    # observe events from ui elements
    observe(TaskViewTapNotification, action:'handleTaskViewTap')
    observe(TaskViewRightSwipeNotification, action:'handleTaskViewRightSwipe')
    observe(TaskViewLeftSwipeNotification, action:'handleTaskViewLeftSwipe')
    observe(AddTappedNotification, action:'handleAddTapped')
    observe(UIKeyboardDidShowNotification, action:'handleKeyboardDidShow')
    
    @scroll_view.drawTasks(@task_store.tasks)
  end

  def handleAddTapped(notification)
    show_task_input
  end

  def handleTaskViewTap(notification)
    @task_store.toggle_dotted(notification.object.taskID)
  end
  
  def handleTaskViewRightSwipe(notification)
    @task_store.remove_task(notification.object.taskID)
  end
  
  def handleTaskViewLeftSwipe(notification)
    @task_store.pause_task(notification.object.taskID)
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
  
  def handleTaskPaused(notification)
    #For now, we just redraw everything
    redraw_tasks
  end
  
  def redraw_tasks
    @scroll_view.redraw_tasks(@task_store.tasks)
  end
  
  def scrollViewDidScroll(scrollView)
    # As currently designed, this is a display memory hog.
    # Here is where we would allocate or deallocate views based on the contentOffset
    @scroll_view.adjust_selected
  end 
  
  # presenter method
  def show_task_input
    text_field_frame = CGRectMake(0, view.frame.size.height - TextEntryHeight, view.frame.size.width, TextEntryHeight)
    @text_field = TaskEntryView.alloc.initWithFrame(text_field_frame)
    @text_field.delegate = self
    
    view.addSubview(@text_field)
    @text_field.becomeFirstResponder
  end
  
  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
    true
  end
  
  def textFieldDidEndEditing(text_field)
    @task_store.add_task(text_field.text)
    hide_task_input
    redraw_tasks
    true
  end
  
  def hide_task_input
    @text_field.removeFromSuperview
    @text_field = nil    
  end
  
  
  def handleKeyboardDidShow(notification)
    adjust_input_size_to_account_for_keyboard(notification.keyboard_height)
  end
  
  
  def adjust_input_size_to_account_for_keyboard(keyboard_height)
    new_frame = CGRectMake(0, view.frame.size.height - TextEntryHeight - keyboard_height, view.frame.size.width, TextEntryHeight)
    UIView.beginAnimations('animationID', context:nil)
    @text_field.frame = new_frame
    UIView.commitAnimations
  end
  
  
  private
  
  def lower_right_frame(subview, padding:padding)
    CGRectMake(view.frame.size.width - padding - subview.frame.size.width, 
               view.frame.size.height - padding - subview.frame.size.height, 
               subview.frame.size.width, 
               subview.frame.size.height)    
  end

  def add_button_view
    button_view = AddButtonView.alloc.init
    button_view.frame = lower_right_frame(button_view, padding:10)
    view.addSubview(button_view)
  end
end

class NSConcreteNotification
  def keyboard_height
    userInfo.objectForKey(UIKeyboardBoundsUserInfoKey).CGRectValue.size.height
  end
end

