class PullTabViewController < UIViewController

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

    App.notification_center.observe(ExpandTappedNotification) do |notification|
      @collapse_toggle_button.toggle
    end
    
    App.notification_center.observe(CollapseTappedNotification) do |notification|
      @collapse_toggle_button.toggle
    end
    
    # observe events from tabbar buttons
    App.notification_center.observe(PullTabViewController::AddTappedNotification) do |notification|
      handleAddTapped
    end
    # observe completion of modal add form
    App.notification_center.observe(AddTaskViewController::AddCompleteNotification) do |notification|
      handleAddComplete
    end

    App.notification_center.observe(PullTabViewController::CameraTappedNotification) do |notification|
      handleCameraTapped
    end
    App.notification_center.observe(PullTabViewController::EmailTappedNotification) do |notification|
      handleEmailTapped
    end
    
  end


  def handleAddTapped
    @add_form_controller = AddTaskViewController.new
    parentViewController.presentModalViewController(@add_form_controller, animated:true)
  end

  def handleAddComplete
    @add_form_controller.dismissModalViewControllerAnimated(true)
    @add_form_controller = nil
  end

  def handleCameraTapped
    imagePicker = UIImagePickerController.alloc.init

    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
      imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera
    else
      imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    end

    imagePicker.mediaTypes = [KUTTypeImage]
    imagePicker.delegate = self
    imagePicker.allowsImageEditing = false
    parentViewController.presentModalViewController(imagePicker, animated:true)
  end

  # UIImagePickerControllerDelegate methods

  def imagePickerControllerDidCancel(picker)
    parentViewController.dismissModalViewControllerAnimated(true)
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info) 
    mediaType = info[UIImagePickerControllerMediaType]
    if mediaType == KUTTypeImage
      editedImage = info[UIImagePickerControllerEditedImage]
      originalImage = info[UIImagePickerControllerOriginalImage]
      TaskStore.shared.add_photo_task(editedImage || originalImage)
    end
    parentViewController.dismissModalViewControllerAnimated(true)
  end

  def handleEmailTapped
    picker = MFMailComposeViewController.alloc.init
    picker.mailComposeDelegate = self

    message = ""
    TaskStore.shared.tasks.each do |task|
      message << (task.dotted? ? "* " : "  ")
      if task.photo?
        message << "[photo]" << "\n"
      else
        message << task.text << "\n"
      end
    end
    subject = "fv list"

    picker.setSubject(subject)
    picker.setMessageBody(message,isHTML:false)

    picker.navigationBar.barStyle = UIBarStyleBlack
    parentViewController.presentModalViewController(picker, animated:true)
  end

  # delegate method for mailer
  def mailComposeController(controller, didFinishWithResult:result, error:error)
    controller.dismissModalViewControllerAnimated(true)
  end

  



end