class AddTaskViewController < UIViewController

  TextEntryHeight = 40
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    view.backgroundColor = UIColor.grayColor
    text_field_frame = CGRectMake(10, 10, view.frame.size.width - 20, TextEntryHeight)
    @text_field = UITextField.alloc.initWithFrame(text_field_frame)
    @text_field.backgroundColor = UIColor.whiteColor
    @text_field.borderStyle = UITextBorderStyleRoundedRect
    @text_field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    view.addSubview(@text_field)
    @text_field.delegate = self
    @text_field.becomeFirstResponder
  end

  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
    true
  end
    
  def textFieldDidEndEditing(text_field)
    TaskList.shared.add_text_task(text_field.text)
    presentingViewController.dismissModalViewControllerAnimated(true)
    true
  end

  
end