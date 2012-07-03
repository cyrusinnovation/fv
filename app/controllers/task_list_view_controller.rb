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
    observe(TaskAddedNotification, action:'handleModelChange')
    observe(TaskChangedNotification, action:'handleModelChange')
    observe(TaskRemovedNotification, action:'handleModelChange')
    observe(TaskPausedNotification, action:'handleModelChange')

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

  def handleTaskViewTap(notification)
    @task_store.toggle_dotted(notification.object.taskID)
  end
  
  def handleTaskViewRightSwipe(notification)
    @task_store.remove_task(notification.object.taskID)
  end
  
  def handleTaskViewLeftSwipe(notification)
    @task_store.pause_task(notification.object.taskID)
  end
  
  def handleModelChange(notification)
    view.redraw_tasks(@task_store.tasks)
  end
  
  def scrollViewDidScroll(scrollView)
    publish(ScrollViewMovedNotification)
  end 
  
  
end