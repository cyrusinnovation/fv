class EmailButtonView < UIImageView
  include Notifications
  
  def init
    button_image = UIImage.imageNamed("email_button.png")
    if initWithImage(button_image)
      self.userInteractionEnabled = true
      button_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:'handleEmailTapped')
      self.addGestureRecognizer(button_recognizer)  
    end
    self
  end
  
  def handleEmailTapped
    publish(EmailTappedNotification)
  end  
  
end