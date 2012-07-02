class TaskListViewController < UIViewController
  include Notifications

  def initWithStore(task_store)
    if init
      @task_store = task_store
    end
    self
  end

  def loadView
    self.view = TaskListView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    view.delegate = self

    # Observe button actions
    observe(ExpandTappedNotification, action:'handleExpandTapped')
    observe(CollapseTappedNotification, action:'handleCollapseTapped')

    # Observe model changes.
    observe(TaskAddedNotification, action:'handleTaskAdded')
    observe(TaskChangedNotification, action:'handleTaskChanged')
    observe(TaskRemovedNotification, action:'handleTaskRemoved')
    observe(TaskPausedNotification, action:'handleTaskPaused')

    # Observe ui events
    observe(TaskViewTapNotification, action:'handleTaskViewTap')
    observe(TaskViewRightSwipeNotification, action:'handleTaskViewRightSwipe')
    observe(TaskViewLeftSwipeNotification, action:'handleTaskViewLeftSwipe')


    view.drawTasks(@task_store.tasks)
  end

  def handleCollapseTapped(notification)
    view.collapse(@task_store.tasks)
  end
  
  def handleExpandTapped(notification)
    view.expand(@task_store.tasks)
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

  def handleTaskViewTap(notification)
    @task_store.toggle_dotted(notification.object.taskID)
  end
  
  def handleTaskViewRightSwipe(notification)
    @task_store.remove_task(notification.object.taskID)
  end
  
  def handleTaskViewLeftSwipe(notification)
    @task_store.pause_task(notification.object.taskID)
  end
  
  
  def redraw_tasks
    view.redraw_tasks(@task_store.tasks)
  end
  
  def scrollViewDidScroll(scrollView)
    # As currently designed, this is a display memory hog.
    # Here is where we would allocate or deallocate views based on the contentOffset
    view.adjust_selected
  end 
  
  
end