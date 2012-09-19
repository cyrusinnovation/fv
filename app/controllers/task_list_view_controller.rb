class TaskListViewController < UIViewController

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
    App.notification_center.observe(PullTabViewController::ExpandTappedNotification) do |notification|
      handleExpandTapped
    end
    App.notification_center.observe(PullTabViewController::CollapseTappedNotification  ) do |notification|
      handleCollapseTapped
    end

    # Observe model changes.
    App.notification_center.observe(TaskStore::TaskAddedNotification) do |notification|
      handleModelChange
    end
    App.notification_center.observe(TaskStore::TaskChangedNotification) do |notification|
      handleModelChange
    end
    App.notification_center.observe(TaskStore::TaskRemovedNotification) do |notification|
      handleModelChange
    end
    App.notification_center.observe(TaskStore::TaskPausedNotification) do |notification|
      handleModelChange
    end
    App.notification_center.observe(TaskStore::TaskListCollapsedNotification) do |notification|
      handleModelChange
    end
    App.notification_center.observe(TaskStore::TaskListExpandedNotification) do |notification|
      handleModelChange
    end

    # Observe ui events
    App.notification_center.observe(TaskView::TaskViewTapNotification) do |notification|
      handleTaskViewTap(notification)
    end
    App.notification_center.observe(TaskView::TaskViewRightSwipeNotification) do |notification|
      handleTaskViewRightSwipe(notification)
    end
    App.notification_center.observe(TaskView::TaskViewLeftSwipeNotification) do |notification|
      handleTaskViewLeftSwipe(notification)
    end

    view.drawTasks(@task_store.tasks)
  end

  def handleCollapseTapped
    @task_store.collapse
  end
  
  def handleExpandTapped
    @task_store.expand
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
  
  def handleModelChange
    view.redraw_tasks(@task_store.tasks)
  end
  
  
end