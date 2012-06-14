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
    
    puts "click!"
    
    # 
    # DBSession.sharedSession.linkFromController(self) unless DBSession.sharedSession.isLinked
    # 
    # writeToTextFile
    
    # localPath = NSBundle.mainBundle.pathForResource("Info", ofType:"plist");
    # filename = "Info.plist";
    # destDir = "/";
    # restClient.uploadFile(filename, toPath:destDir, withParentRev:nil, fromPath:localPath);
  end
  
end