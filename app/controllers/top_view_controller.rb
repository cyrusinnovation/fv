class TopViewController < UIViewController
  include Notifications
  
  def loadView
    self.view = TopView.alloc.initWithFrame(CGRectMake(0,0,UIScreen.mainScreen.applicationFrame.size.width,TaskListView::TaskHeight))
    observe(ScrollViewMovedNotification, action:'handleScrollViewMoved')
  end

  def handleScrollViewMoved(notification)
    NSLog("#{notification.object.view.contentOffset.y}")
  end


end