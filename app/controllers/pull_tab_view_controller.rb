class PullTabViewController < UIViewController

  def loadView
    add_button = ButtonView.withImage("add_button.png") { showModal(AddTaskViewController) }
    camera_button = ButtonView.withImage("camera_button.png") { showModal(TaskImageController) }
    email_button = ButtonView.withImage("email_button.png") { showModal(TaskEmailController) }

    collapse_button = ButtonView.withImage("collapse_button.png") { handleCollapseTapped }
    expand_button = ButtonView.withImage("expand_button.png") { handleExpandTapped }
    @collapse_toggle_button = ToggleButtonView.alloc.initWithFirstView(collapse_button, secondView:expand_button)

    self.view = PullTabView.alloc.initWithButtons([add_button, camera_button, email_button, @collapse_toggle_button])
  end
  
  def handleCollapseTapped
    TaskList.shared.collapse
    @collapse_toggle_button.toggle
  end
  
  def handleExpandTapped
    TaskList.shared.expand
    @collapse_toggle_button.toggle
  end
  
  private
  
  def showModal(controllerClass)
    parentViewController.presentModalViewController(controllerClass.new, animated:true)
  end
  
end
