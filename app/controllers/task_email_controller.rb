class TaskEmailController < MFMailComposeViewController
  
  def init
    if super
      self.navigationBar.barStyle = UIBarStyleBlack
      compose_mail
      self.mailComposeDelegate = self
    end
    self
  end

  def mailComposeController(controller, didFinishWithResult:result, error:error)
    controller.dismissModalViewControllerAnimated(true)
  end


  def compose_mail
    message = ""
    TaskList.shared.all_tasks.each do |task|
      message << (task.dotted? ? "* " : "  ")
      if task.photo?
        message << "[photo]" << "\n"
      else
        message << task.text << "\n"
      end
    end
    subject = "fv list"

    self.setSubject(subject)
    self.setMessageBody(message,isHTML:false)
  end
  
  
end