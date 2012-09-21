class UIView
  
  def when_swiped_up(enableInteraction=true, &proc)
    when_swiped_in_direction(UISwipeGestureRecognizerDirectionUp, enableInteraction, &proc)
  end

  def when_swiped_down(enableInteraction=true, &proc)
    when_swiped_in_direction(UISwipeGestureRecognizerDirectionDown, enableInteraction, &proc)
  end

  def when_swiped_left(enableInteraction=true, &proc)
    when_swiped_in_direction(UISwipeGestureRecognizerDirectionLeft, enableInteraction, &proc)
  end

  def when_swiped_right(enableInteraction=true, &proc)
    when_swiped_in_direction(UISwipeGestureRecognizerDirectionRight, enableInteraction, &proc)
  end
  
  private
  
  def when_swiped_in_direction(direction, enableInteraction=true, &proc)
    recognizer = when_swiped(enableInteraction, &proc)
    recognizer.direction = direction
    recognizer
  end

end