class MainViewController < UIViewController
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    add_child_controller(TaskTableViewController.new)
    add_child_controller(PullTabViewController.new)
    wire_task_store_events
  end

  def wire_task_store_events
    # Observe button actions
    App.notification_center.observe(PullTabViewController::ExpandTappedNotification) do |notification|
      TaskStore.shared.expand
    end
    App.notification_center.observe(PullTabViewController::CollapseTappedNotification  ) do |notification|
      TaskStore.shared.collapse
    end

    # Observe ui events
    App.notification_center.observe(TaskTableCell::TaskViewTapNotification) do |notification|
      TaskStore.shared.toggle_dotted(notification.object.taskID)
    end
    App.notification_center.observe(TaskTableCell::TaskViewRightSwipeNotification) do |notification|
      TaskStore.shared.remove_task(notification.object.taskID)
    end
    App.notification_center.observe(TaskTableCell::TaskViewLeftSwipeNotification) do |notification|
      TaskStore.shared.pause_task(notification.object.taskID)
    end
    
  end


end


