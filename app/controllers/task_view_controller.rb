class TaskViewController < UIViewController
  include Notifications
  
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
    
    # observe events from tabbar buttons
    observe(AddTappedNotification, action:'handleAddTapped')
    observe(EmailTappedNotification, action:'handleEmailTapped')
    
    # observe completion of modal add form
    observe(AddCompleteNotification, action:'handleAddComplete')
    
  end
  

  def handleAddTapped(notification)
    @add_form_controller = AddTaskViewController.alloc.initWithStore(@task_store)
    presentModalViewController(@add_form_controller, animated:true)
  end
  
  def handleAddComplete(notification)
    @add_form_controller.dismissModalViewControllerAnimated(true)
    @add_form_controller = nil
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
    @top_controller = TopViewController.alloc.initWithStore(@task_store)
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

