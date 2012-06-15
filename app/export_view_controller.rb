class ExportViewController < UIViewController
  include Notifications
  
  def initWithDropboxService(dropbox_service, file_exporter:file_exporter)
    if init
      @dropbox_service = dropbox_service
      @file_exporter = file_exporter
      self.title = 'Export'
    end
    self
  end  
  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    
    @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button.frame = CGRectMake(10,10,view.frame.size.width - 20,50)
    @button.addTarget(self, action:'buttonClicked', forControlEvents:UIControlEventTouchUpInside)
    @button.setTitle("Exporting...",forState:UIControlStateDisabled)
    @button.setTitle("Export to Dropbox",forState:UIControlStateNormal)

    label_frame = CGRectMake(10, 70, view.frame.size.width - 20, 50)
    @label = UILabel.alloc.initWithFrame(label_frame)
    @label.backgroundColor = UIColor.blackColor
    @label.textColor = UIColor.whiteColor
    
    # Observe export events
    observe(DropboxFileUploadedNotification, action:'handleDropboxFileUploaded')
    observe(DropboxFileUploadFailedNotification, action:'handleDropboxFileUploadFailed')

    view.addSubview(@button)  
    view.addSubview(@label)  
  end
  
  def handleDropboxFileUploaded(notification)
    @button.enabled = true
  end
  
  def handleDropboxFileUploadFailed(notification)
    @label.text = "Upload failed"
    @button.enabled = true
  end
  
  def buttonClicked
    @button.enabled = false
    
    localPath = @file_exporter.export_to_temp_file
    filename = "tasks.txt"
    destDir = "/"

    @dropbox_service.uploadFile(filename, toPath:destDir, fromPath:localPath, fromController:self)
  end

  
  
end