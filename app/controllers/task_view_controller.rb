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

    add_button_views

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
    observe(EmailTappedNotification, action:'handleEmailTapped')
    observe(UIKeyboardDidShowNotification, action:'handleKeyboardDidShow')
    
    @editing_task = false
    
    @scroll_view.drawTasks(@task_store.tasks)
  end

  def handleAddTapped(notification)
    show_task_input
  end
  
  def handleEmailTapped(notification)
    picker = MFMailComposeViewController.alloc.init
    picker.mailComposeDelegate = self

    message = ""
    @task_store.tasks.each do |task|
      message << (task.dotted? ? "* " : "  ")
      message << task.text << "\n"
    end
    subject = "fv list"

    picker.setSubject(subject)
    picker.setMessageBody(message,isHTML:false)

    picker.navigationBar.barStyle = UIBarStyleBlack
    presentModalViewController(picker, animated:true)
  end

  # delegate method for mailer
  def mailComposeController(controller, didFinishWithResult:result, error:error)
    controller.dismissModalViewControllerAnimated(true)
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
    @editing_task = true

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
    @editing_task = false
  end
  
  
  def handleKeyboardDidShow(notification)
    adjust_input_size_to_account_for_keyboard(notification.keyboard_height) if @editing_task
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
  
  def lower_left_frame(subview, padding:padding)
    CGRectMake(padding, 
               view.frame.size.height - padding - subview.frame.size.height, 
               subview.frame.size.width, 
               subview.frame.size.height)    
  end
  
  def upper_right_frame(subview, padding:padding)
    CGRectMake(view.frame.size.width - padding - subview.frame.size.width, 
               padding, 
               subview.frame.size.width, 
               subview.frame.size.height)    
  end

  def add_button_views
    add_button_view = AddButtonView.alloc.init
    add_button_view.frame = lower_right_frame(add_button_view, padding:10)
    view.addSubview(add_button_view)

    email_button_view = EmailButtonView.alloc.init
    email_button_view.frame = upper_right_frame(email_button_view, padding:10)
    view.addSubview(email_button_view)
  end
  
end

class NSConcreteNotification
  def keyboard_height
    userInfo.objectForKey(UIKeyboardBoundsUserInfoKey).CGRectValue.size.height
  end
end

