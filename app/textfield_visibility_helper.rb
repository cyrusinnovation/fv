class TextFieldVisibilityHelper
  include Notifications
  
  def initialize(text_field)
    observe(UIKeyboardDidShowNotification, action:'keyboardDidShow')
    observe(UIKeyboardWillHideNotification, action:'keyboardWillHide')
    @text_field = text_field
  end
  
  def keyboardDidShow(notification)
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