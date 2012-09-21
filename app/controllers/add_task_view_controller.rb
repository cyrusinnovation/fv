class AddTaskViewController < UIViewController

  AddCompleteNotification = 'AddComplete'

  TextEntryHeight = 40
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    view.backgroundColor = UIColor.grayColor
    text_field_frame = CGRectMake(10, 10, view.frame.size.width - 20, TextEntryHeight)
    @text_field = TaskEntryView.alloc.initWithFrame(text_field_frame)
    view.addSubview(@text_field)
    @text_field.delegate = self
    @text_field.becomeFirstResponder
  end

  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
    true
  end
    
  def textFieldDidEndEditing(text_field)
    TaskStore.shared.add_text_task(text_field.text)
    App.notification_center.post(AddCompleteNotification)
    true
  end

  
end