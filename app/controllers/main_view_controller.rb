class MainViewController < UIViewController
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    add_child_controller(TaskTableViewController.new)
    add_child_controller(PullTabViewController.new)
  end

end


