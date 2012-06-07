class TextFieldVisibilityHelper
  
  def initialize(text_field)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardDidShow:', name:UIKeyboardDidShowNotification, object:nil)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillHide:', name:UIKeyboardWillHideNotification, object:nil)
    @text_field = text_field
  end
  
  def keyboardDidShow(notification)
    puts notification.userInfo.keys
    @old_frame = @text_field.frame
    new_frame = CGRectOffset(@old_frame, 0, -notification.keyboard_height)
    animateTextFieldMove(new_frame)
  end
  
  def keyboardWillHide(notification)
    animateTextFieldMove(@old_frame)
  end

  private 

  def animateTextFieldMove(frame)
    UIView.beginAnimations('animationID', context:nil)
    @text_field.frame = frame
    UIView.commitAnimations
  end
  
  def frame_with_offset(offset)
    text_field_height = @text_field.frame.size.height
    CGRectOffset(@original_frame, 0, -offset)
  end
  
end

class NSConcreteNotification
  def keyboard_height
    userInfo.objectForKey(UIKeyboardBoundsUserInfoKey).CGRectValue.size.height
  end
end