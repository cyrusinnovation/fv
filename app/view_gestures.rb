class UIView
  
  def whenSwipedUp(enableInteraction=true, &proc)
    whenSwipedInDirection(UISwipeGestureRecognizerDirectionUp, enableInteraction, &proc)
  end

  def whenSwipedDown(enableInteraction=true, &proc)
    whenSwipedInDirection(UISwipeGestureRecognizerDirectionDown, enableInteraction, &proc)
  end

  def whenSwipedLeft(enableInteraction=true, &proc)
    whenSwipedInDirection(UISwipeGestureRecognizerDirectionLeft, enableInteraction, &proc)
  end

  def whenSwipedRight(enableInteraction=true, &proc)
    whenSwipedInDirection(UISwipeGestureRecognizerDirectionRight, enableInteraction, &proc)
  end
  
  private
  
  def whenSwipedInDirection(direction, enableInteraction=true, &proc)
    recognizer = whenSwiped(enableInteraction, &proc)
    recognizer.direction = direction
    recognizer
  end

end