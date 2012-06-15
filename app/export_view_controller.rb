class ExportViewController < UIViewController
  
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
    
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = CGRectMake(10,10,view.frame.size.width - 20,50)
    button.addTarget(self, action:'buttonClicked', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle("Export to Dropbox",forState:UIControlStateNormal)

    view.addSubview(button)    
  end
  
  def buttonClicked
    localPath = @file_exporter.export_to_temp_file
    filename = "tasks.txt"
    destDir = "/"

    @dropbox_service.uploadFile(filename, toPath:destDir, fromPath:localPath, fromController:self)
  end

  
  
end