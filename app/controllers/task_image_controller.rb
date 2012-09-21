class TaskImageController < UIImagePickerController
  
  def viewDidLoad
    self.sourceType = has_camera? ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary
    self.mediaTypes = [KUTTypeImage]
    self.delegate = self
    self.allowsImageEditing = false
  end
  
  def imagePickerControllerDidCancel(picker)
    presentingViewController.dismissModalViewControllerAnimated(true)
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info) 
    mediaType = info[UIImagePickerControllerMediaType]
    TaskList.shared.add_photo_task(info[UIImagePickerControllerOriginalImage])
    presentingViewController.dismissModalViewControllerAnimated(true)
  end
  
  def has_camera?
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
  end
  
end