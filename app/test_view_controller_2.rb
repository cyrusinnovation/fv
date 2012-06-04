class TestViewController2 < UIViewController
  ItemHeight = 100


  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    colors = [UIColor.darkGrayColor, UIColor.cyanColor, UIColor.magentaColor, UIColor.orangeColor, UIColor.purpleColor, UIColor.brownColor, UIColor.redColor, UIColor.blueColor, UIColor.greenColor, UIColor.yellowColor]
    scrollView = UIScrollView.alloc.initWithFrame(view.frame)
    scrollView.delegate = self
    view.addSubview(scrollView)
    
    colors.each_index do |index|
      subview = UIView.alloc.initWithFrame(CGRectMake(0, ItemHeight * index, scrollView.frame.size.width, ItemHeight))
      subview.backgroundColor = colors[index]
      scrollView.addSubview(subview)
    end
    
    @grayView = scrollView.subviews[0]
    @orangeView = scrollView.subviews[3]
    
    scrollView.contentSize = CGSizeMake(view.frame.size.width, ItemHeight * colors.size);
  end
  
  def scrollViewDidScroll(scrollView)
    yoffset = scrollView.contentOffset.y
    
    # Draw the gray frame at top if scrolled away
    if yoffset > 0
      newFrame = CGRectMake(0,yoffset,scrollView.frame.size.width,ItemHeight)
      @grayView.frame = newFrame
      scrollView.bringSubviewToFront(@grayView)
    end
        
    if yoffset > ItemHeight * 2
      newFrame = CGRectMake(0,yoffset,scrollView.frame.size.width,ItemHeight)
      @orangeView.frame = newFrame
      scrollView.bringSubviewToFront(@orangeView)
    end
  end
  
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
  end
end
