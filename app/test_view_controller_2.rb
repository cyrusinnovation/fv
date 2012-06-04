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
    @redView = scrollView.subviews[6]
    
    # We would know how to 
    scrollView.bringSubviewToFront(@grayView)
    scrollView.bringSubviewToFront(@orangeView)
    scrollView.bringSubviewToFront(@redView)
    
    scrollView.contentSize = CGSizeMake(view.frame.size.width, ItemHeight * colors.size);
  end
  
  def scrollViewDidScroll(scrollView)
    yoffset = scrollView.contentOffset.y
    
    # Draw the gray frame at top if scrolled away
    if yoffset > 0
      newFrame = CGRectMake(0,yoffset,scrollView.frame.size.width,ItemHeight)
      @grayView.frame = newFrame
    else
      newFrame = CGRectMake(0,0,scrollView.frame.size.width,ItemHeight)
      @grayView.frame = newFrame
    end
    
    if yoffset > ItemHeight * 3
      newFrame = CGRectMake(0,yoffset,scrollView.frame.size.width,ItemHeight)
      @orangeView.frame = newFrame
    else
      newFrame = CGRectMake(0,ItemHeight * 3,scrollView.frame.size.width,ItemHeight)
      @orangeView.frame = newFrame
    end
    
    if yoffset > ItemHeight * 6
      newFrame = CGRectMake(0, yoffset, scrollView.frame.size.width,ItemHeight)
      @redView.frame = newFrame
    else
      newFrame = CGRectMake(0, ItemHeight * 6, scrollView.frame.size.width, ItemHeight)
      @redView.frame = newFrame
    end
    
  end
  
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
  end
end
