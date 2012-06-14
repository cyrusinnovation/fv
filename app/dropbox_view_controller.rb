class DropboxViewController < UIViewController
  def loadView
    view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    view.backgroundColor = UIColor.redColor
  end
end