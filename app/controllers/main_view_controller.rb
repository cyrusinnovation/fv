class MainViewController < UIViewController
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    add_child_controller(TaskTableViewController.new)
    add_child_controller(PullTabViewController.new)
    wire_task_list_events
  end

  def wire_task_list_events
    App.notification_center.observe(TaskTableCell::TaskViewTapNotification) do |notification|
      TaskList.shared.toggle_dotted(notification.object.taskID)
    end
    App.notification_center.observe(TaskTableCell::TaskViewRightSwipeNotification) do |notification|
      TaskList.shared.remove_task(notification.object.taskID)
    end
    App.notification_center.observe(TaskTableCell::TaskViewLeftSwipeNotification) do |notification|
      TaskList.shared.pause_task(notification.object.taskID)
    end
    
  end


end


