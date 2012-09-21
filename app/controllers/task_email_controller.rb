class TaskEmailController < MFMailComposeViewController
  
  def init
    if super
      self.navigationBar.barStyle = UIBarStyleBlack
      TaskList.shared.compose_mail(self)
      self.mailComposeDelegate = self
    end
    self
  end

  def mailComposeController(controller, didFinishWithResult:result, error:error)
    controller.dismissModalViewControllerAnimated(true)
  end
  
end