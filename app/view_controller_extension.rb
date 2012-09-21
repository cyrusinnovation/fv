class UIViewController
  
  def add_child_controller(child_controller)
    self.addChildViewController(child_controller)
    child_controller.didMoveToParentViewController(self)
    self.view.addSubview(child_controller.view)
  end
  
  
end