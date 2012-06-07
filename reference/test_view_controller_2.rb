class TestViewController2 < UIViewController
  ItemHeight = 100


  
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    colors = [UIColor.darkGrayColor, UIColor.cyanColor, UIColor.magentaColor, UIColor.orangeColor, UIColor.purpleColor, UIColor.brownColor, UIColor.redColor, UIColor.blueColor, UIColor.greenColor, UIColor.yellowColor]
    scrollView = UIScrollView.alloc.initWithFrame(view.frame)
    scrollView.delegate = self
    view.addSubview(scrollView)
    
    @myviews = []
    colors.each_index do |index|
      subview = UIView.alloc.initWithFrame(CGRectMake(0, ItemHeight * index, scrollView.frame.size.width, ItemHeight))
      subview.backgroundColor = colors[index]
      scrollView.addSubview(subview)
      @myviews << subview
    end
    
    @selected_indexes = [0,2,4,6,7,8]
    @selected_indexes.each do |index|
      scrollView.bringSubviewToFront(@myviews[index])
    end
    
    scrollView.contentSize = CGSizeMake(view.frame.size.width, ItemHeight * colors.size);
  end
  
  def scrollViewDidScroll(scrollView)
    yoffset = scrollView.contentOffset.y
    
    @selected_indexes.each do |index|
      subview = @myviews[index]
      if yoffset > ItemHeight * index
        newFrame = CGRectMake(0,yoffset,scrollView.frame.size.width,ItemHeight)
        subview.frame = newFrame
      else
        newFrame = CGRectMake(0,ItemHeight * index,scrollView.frame.size.width,ItemHeight)
        subview.frame = newFrame
      end
    end
  end
  
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
  end
end
