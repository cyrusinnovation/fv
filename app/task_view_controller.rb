class TaskViewController < UIViewController
  include Notifications
  
  TaskHeight = 40
  TextEntryHeight = 40
  
  def initWithStore(task_store)
    if init
      @task_store = task_store
    end
    self
  end
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    
    scroll_view_frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - TextEntryHeight)
    @scroll_view = UIScrollView.alloc.initWithFrame(scroll_view_frame)
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
    
    drawTasks
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
      y = y_for_view(index, @selected_indexes_for_adjust, yoffset)
      @task_views_for_adjust[index].frame = CGRectMake(0,y,@scroll_view.frame.size.width,TaskHeight)
    end    
  end
  
  def drawTasks

    selected_indexes = []
    @task_store.tasks.each_index do |index|
      task = @task_store.tasks[index]
      if task.dotted?
        selected_indexes << index
      end
    end

    yoffset = @scroll_view.contentOffset.y

    task_views = []
    @task_store.tasks.each_index do |index|
      task = @task_store.tasks[index]
      y = y_for_view(index, selected_indexes, yoffset)
      task_frame = CGRectMake(0, y, @scroll_view.frame.size.width, TaskHeight)
      subview = TaskView.alloc.initWithFrame(task_frame, task:task, position:index)
      task_views << subview
      @scroll_view.addSubview(subview)
    end
    
    selected_indexes.each do |index|
      @scroll_view.bringSubviewToFront(task_views[index])
    end
    
    @scroll_view.contentSize = CGSizeMake(@scroll_view.frame.size.width, @task_store.tasks.size * TaskHeight)
    
    collect_adjust_data

  end

  def y_for_view(index, selected_indexes, yoffset)
    
    # This is the position of the indexth view would
    # take if there wasn't any stickiness
    normal_pos = TaskHeight * index
    
    # position of index within list of selected indexes
    # nil if not present
    selected_index = selected_indexes.index(index)
    
    # If the selected_indexes doesn't contain index, then 
    # that view isn't one of a selected one.
    return normal_pos unless selected_index

    # If the normal position is far enough down then just put it in
    # its normal spot.
    return normal_pos if normal_pos > yoffset

    # Get the index into the list of views for the next selected view
    # if it exists
    next_selected = selected_indexes[selected_index + 1]

    if next_selected
      next_normal_pos = next_selected * TaskHeight
      
      # If the next selected is bumping into this one, get out of the way
      if next_normal_pos > yoffset && next_normal_pos < yoffset + TaskHeight
        return next_normal_pos - TaskHeight
      else
        return yoffset
      end
    else
      if yoffset > normal_pos 
        return yoffset
      else
        return normal_pos
      end
    end
  end


  def collect_adjust_data
    @task_views_for_adjust = []
    @scroll_view.subviews.each do |subview|
      @task_views_for_adjust[subview.position] = subview
    end

    @selected_indexes_for_adjust = []
    @task_store.tasks.each_index do |index|
      task = @task_store.tasks[index]
      if task.dotted?
        @selected_indexes_for_adjust << index
      end
    end
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

