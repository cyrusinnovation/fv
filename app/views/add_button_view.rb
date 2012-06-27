class AddButtonView < UIImageView
  include Notifications
  
  def init
    button_image = UIImage.imageNamed("add_button.png")
    if initWithImage(button_image)
      self.userInteractionEnabled = true
      button_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:'handleAddTapped')
      self.addGestureRecognizer(button_recognizer)  
    end
    
    self
  end
  
  # handler for add button
  def handleAddTapped
    publish(AddTappedNotification)
  end  
  
end