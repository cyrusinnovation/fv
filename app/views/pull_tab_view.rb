class PullTabView < UIView
  Padding = 10
  
  def initWithButtons(buttons)
    
    height = buttons.inject(Padding) { |height, button| height + button.frame.size.height + Padding }
    width = buttons.max_by { |button| button.frame.size.width }.frame.size.width + (2 * Padding)
    
    if initWithFrame(CGRectMake(0,0,width,height))
      y = 0
      buttons.each do |button|
        y += Padding
        button.frame = CGRectMake(Padding, y, button.frame.size.height, button.frame.size.width)
        y += button.frame.size.height
        self.addSubview(button)
      end
    end
    self
  end
  
  def willMoveToSuperview(superview)
    new_x = superview.frame.size.width - self.frame.size.width
    new_y = superview.frame.size.height - self.frame.size.height
    self.frame = CGRectMake(new_x, new_y, self.frame.size.width, self.frame.size.height)
  end
  
  
  
end