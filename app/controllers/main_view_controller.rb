class MainViewController < UIViewController
  
  def initWithStore(task_store)
    if init
      @task_store = task_store
    end
    self
  end
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    add_child_controller(TaskListViewController.alloc.initWithStore(@task_store))
    add_child_controller(PullTabViewController.alloc.initWithStore(@task_store))
    wire_task_store_events
  end

  def wire_task_store_events
    # Observe button actions
    App.notification_center.observe(PullTabViewController::ExpandTappedNotification) do |notification|
      @task_store.expand
    end
    App.notification_center.observe(PullTabViewController::CollapseTappedNotification  ) do |notification|
      @task_store.collapse
    end

    # Observe ui events
    App.notification_center.observe(TaskView::TaskViewTapNotification) do |notification|
      @task_store.toggle_dotted(notification.object.taskID)
    end
    App.notification_center.observe(TaskView::TaskViewRightSwipeNotification) do |notification|
      @task_store.remove_task(notification.object.taskID)
    end
    App.notification_center.observe(TaskView::TaskViewLeftSwipeNotification) do |notification|
      @task_store.pause_task(notification.object.taskID)
    end
    
  end


end


