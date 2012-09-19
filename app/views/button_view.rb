class ButtonView < UIImageView
  
  def initWithImageNamed(imageName, tapNotification:notification)
    @notification = notification
    button_image = UIImage.imageNamed(imageName)
    if initWithImage(button_image)
      whenTapped do
        App.notification_center.post(@notification)
      end
    end
    self
  end
  
end