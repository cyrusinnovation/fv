class TaskEntryView < UITextField
  include Notifications
  
  def initWithFrame(frame)
    if super
      self.backgroundColor = UIColor.whiteColor
      self.borderStyle = UITextBorderStyleRoundedRect
      self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    end
    self
  end
  
  
end