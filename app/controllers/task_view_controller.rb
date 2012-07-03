class TaskViewController < UIViewController
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

    add_list_controller
    add_top_controller
    add_pull_tab_controller
    

    # observe events from ui elements
    observe(UIKeyboardDidShowNotification, action:'handleKeyboardDidShow')

    # observe events from tabbar buttons
    observe(AddTappedNotification, action:'handleAddTapped')
    observe(EmailTappedNotification, action:'handleEmailTapped')

  end
  

  def handleAddTapped(notification)
    show_task_input
  end
  

  def handleEmailTapped(notification)
    picker = MFMailComposeViewController.alloc.init
    picker.mailComposeDelegate = self

    message = ""
    @task_store.tasks.each do |task|
      message << (task.dotted? ? "* " : "  ")
      message << task.text << "\n"
    end
    subject = "fv list"

    picker.setSubject(subject)
    picker.setMessageBody(message,isHTML:false)

    picker.navigationBar.barStyle = UIBarStyleBlack
    presentModalViewController(picker, animated:true)
  end

  # delegate method for mailer
  def mailComposeController(controller, didFinishWithResult:result, error:error)
    controller.dismissModalViewControllerAnimated(true)
  end

  
  # presenter method
  def show_task_input
    @editing_task = true

    text_field_frame = CGRectMake(0, view.frame.size.height - TextEntryHeight, view.frame.size.width, TextEntryHeight)
    @text_field = TaskEntryView.alloc.initWithFrame(text_field_frame)
    @text_field.delegate = self
    
    view.addSubview(@text_field)
    @text_field.becomeFirstResponder
  end
  
  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
    true
  end
  
  def textFieldDidEndEditing(text_field)
    @task_store.add_task(text_field.text)
    hide_task_input
    true
  end
  
  def hide_task_input
    @text_field.removeFromSuperview
    @text_field = nil    
    @editing_task = false
  end
  
  
  def handleKeyboardDidShow(notification)
    adjust_input_size_to_account_for_keyboard(notification.keyboard_height) if @editing_task
  end
  
  
  def adjust_input_size_to_account_for_keyboard(keyboard_height)
    new_frame = CGRectMake(0, view.frame.size.height - TextEntryHeight - keyboard_height, view.frame.size.width, TextEntryHeight)
    UIView.beginAnimations('animationID', context:nil)
    @text_field.frame = new_frame
    UIView.commitAnimations
  end
  
  
  private
  
  def add_list_controller
    @list_controller = TaskListViewController.alloc.initWithStore(@task_store)
    self.addChildViewController(@list_controller)
    @list_controller.didMoveToParentViewController(self)
    @list_controller.view.frame = CGRectMake(0,0,view.frame.size.width,view.frame.size.height)
    self.view.addSubview(@list_controller.view)
  end
  
  def add_pull_tab_controller
    @pull_tab_controller = PullTabViewController.alloc.init
    self.addChildViewController(@pull_tab_controller)
    @pull_tab_controller.didMoveToParentViewController(self)
    self.view.addSubview(@pull_tab_controller.view)
  end
  
  def add_top_controller
    @top_controller = TopViewController.alloc.init
    self.addChildViewController(@top_controller)
    @top_controller.didMoveToParentViewController(self)
    self.view.addSubview(@top_controller.view)
  end
  
end

class NSConcreteNotification
  def keyboard_height
    userInfo.objectForKey(UIKeyboardBoundsUserInfoKey).CGRectValue.size.height
  end
end

