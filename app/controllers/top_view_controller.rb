class TopViewController < UIViewController
  
  def loadView
    self.view = TopView.alloc.initWithFrame(CGRectMake(0,0,UIScreen.mainScreen.applicationFrame.size.width,TaskListView::TaskHeight))
    
    
  end
end