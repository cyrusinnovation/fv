class ExportViewController < UIViewController
  
  def initWithStore(task_store, dropbox_service:dropbox_service)
    if init
      @task_store = task_store
      @dropbox_service = dropbox_service
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
    localPath = writeToTempFile
    filename = "foo.txt"
    destDir = "/"
    
    @dropbox_service.uploadFile(filename, toPath:destDir, fromPath:localPath, fromController:self)
  end

  
  def writeToTempFile
    dirURL = NSFileManager.defaultManager.URLForDirectory(NSItemReplacementDirectory, inDomain:NSUserDomainMask, appropriateForURL:NSURL.fileURLWithPath("fv"), create:true, error:nil)
    tmpDir = dirURL.path

    #make a file name to write the data to using the documents directory:
    fileName = "#{tmpDir}/textfile.txt"
    
    #create content - four lines of text
    content = "One\nTwo\nThree\nFour\nFive"
    
    #save content to the documents directory
    content.writeToFile(fileName, atomically:false, encoding:NSStringEncodingConversionAllowLossy, error:nil)

    fileName
  end  
  
  
end