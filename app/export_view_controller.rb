class ExportViewController < UIViewController
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    

    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = CGRectMake(10,10,view.frame.size.width - 20,50)
    button.addTarget(self, action:'buttonClicked', forControlEvents:UIControlEventTouchUpInside)
    button.setTitle("Export to Dropbox",forState:UIControlStateNormal)

    view.addSubview(button)    
  end
  
  def buttonClicked
    
    puts "foo"
    DBSession.sharedSession.linkFromController(self) unless DBSession.sharedSession.isLinked

    
    localPath = writeToTempFile
    filename = "foo.txt";
    destDir = "/";
    restClient.uploadFile(filename, toPath:destDir, withParentRev:nil, fromPath:localPath);
  end

  def restClient
    @rest_client ||= begin
      rest_client = DBRestClient.alloc.initWithSession(DBSession.sharedSession)
      rest_client.delegate = self
      rest_client
    end
  end
  
  def restClient(client, uploadedFile:destPath, from:srcPath, metadata:metadata)
    NSLog("File uploaded successfully to path: #{metadata.path}");
  end

  def restClient(client, uploadFileFailedWithError:error)
    NSLog("File upload failed with error - #{error}");
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