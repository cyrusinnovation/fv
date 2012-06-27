class PullTabView < UIView
  Padding = 10
  
  def initWithButtons(buttons)
    
    @full_height = buttons.inject(Padding) { |height, button| height + button.frame.size.height + Padding }
    @minimized_height = buttons[0].frame.size.height + (3 * Padding)
    
    width = buttons.max_by { |button| button.frame.size.width }.frame.size.width + (2 * Padding)
    
    if initWithFrame(CGRectMake(0,0,width,@minimized_height))
      y = 0
      buttons.each do |button|
        y += Padding
        button.frame = CGRectMake(Padding, y, button.frame.size.height, button.frame.size.width)
        y += button.frame.size.height
        self.addSubview(button)
      end
    end
    
    up_swipe_recognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'handleUpSwipe')
    up_swipe_recognizer.direction = UISwipeGestureRecognizerDirectionUp
    self.addGestureRecognizer(up_swipe_recognizer)
    
    down_swipe_recognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'handleDownSwipe')
    down_swipe_recognizer.direction = UISwipeGestureRecognizerDirectionDown
    self.addGestureRecognizer(down_swipe_recognizer)
    
    
    self
  end
  
  def handleUpSwipe
    UIView.beginAnimations('animationID', context:nil)
    self.frame = upFrame
    UIView.commitAnimations
  end
  
  def handleDownSwipe
    UIView.beginAnimations('animationID', context:nil)
    self.frame = downFrame
    UIView.commitAnimations
  end
  
  def upFrame
    new_x = self.superview.frame.size.width - self.frame.size.width
    new_y = self.superview.frame.size.height - @full_height
    CGRectMake(new_x, new_y, self.frame.size.width, @full_height)
  end

  def downFrame
    new_x = self.superview.frame.size.width - self.frame.size.width
    new_y = self.superview.frame.size.height - @minimized_height
    CGRectMake(new_x, new_y, self.frame.size.width, @full_height)
  end

  
  def didMoveToSuperview
    self.frame = downFrame
  end
  
  
  
end