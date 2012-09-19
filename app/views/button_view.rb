class ButtonView < UIImageView
  
  def initWithImageNamed(imageName, tapNotification:notification)
    @notification = notification
    button_image = UIImage.imageNamed(imageName)
    if initWithImage(button_image)
      self.userInteractionEnabled = true
      button_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:'handleTap')
      self.addGestureRecognizer(button_recognizer)  
    end
    self
  end
  
  def handleTap
    App.notification_center.post(@notification)
  end  
  
end