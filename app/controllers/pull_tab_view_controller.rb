class PullTabViewController < UIViewController
  include Notifications

  AddTappedNotification = 'AddTapped'
  ExpandTappedNotification = 'ExpandTapped'
  CameraTappedNotification = 'CameraTapped'
  CollapseTappedNotification = 'CollapseTapped'
  EmailTappedNotification = 'EmailTapped'

  
  def loadView
    add_button = ButtonView.alloc.initWithImageNamed("add_button.png", tapNotification:AddTappedNotification)
    camera_button = ButtonView.alloc.initWithImageNamed("camera_button.png", tapNotification:CameraTappedNotification)
    email_button = ButtonView.alloc.initWithImageNamed("email_button.png", tapNotification:EmailTappedNotification)
    collapse_button = ButtonView.alloc.initWithImageNamed("collapse_button.png", tapNotification:CollapseTappedNotification)
    expand_button = ButtonView.alloc.initWithImageNamed("expand_button.png", tapNotification:ExpandTappedNotification)
    @collapse_toggle_button = ToggleButtonView.alloc.initWithFirstView(collapse_button, secondView:expand_button)

    self.view = PullTabView.alloc.initWithButtons([add_button, camera_button, email_button, @collapse_toggle_button])

    observe(ExpandTappedNotification, action:'handleExpandTapped')
    observe(CollapseTappedNotification, action:'handleCollapseTapped')
  end

  def handleCollapseTapped(notification)
    @collapse_toggle_button.toggle
  end
  
  def handleExpandTapped(notification)
    @collapse_toggle_button.toggle
  end


end