class ButtonView < UIImageView
  
  def self.withImage(imageName, &proc)
    self.alloc.initWithImageNamed(imageName, &proc)
  end
  
  def initWithImageNamed(imageName, &proc)
    button_image = UIImage.imageNamed(imageName)
    if initWithImage(button_image)
      when_tapped { proc.call }
    end
    self
  end

end
