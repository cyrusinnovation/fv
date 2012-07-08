class AddTaskViewController < UIViewController
  include Notifications
  
  TextEntryHeight = 40
  
  def initWithStore(task_store)
    if init
      @task_store = task_store
    end
    self      
  end
  
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
    @task_store.add_text_task(text_field.text)
    publish(AddCompleteNotification)
    true
  end

  
end