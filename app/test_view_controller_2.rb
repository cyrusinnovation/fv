class TestViewController2 < UIViewController
  ItemHeight = 100


  
  def loadView
    self.view = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    colors = [UIColor.darkGrayColor, UIColor.cyanColor, UIColor.magentaColor, UIColor.orangeColor, UIColor.purpleColor, UIColor.brownColor, UIColor.redColor, UIColor.blueColor, UIColor.greenColor, UIColor.yellowColor]
    
    colors.each_index do |index|
      subview = UIView.alloc.initWithFrame(CGRectMake(0, ItemHeight * index, view.frame.size.width, ItemHeight))
      subview.backgroundColor = colors[index]
      view.addSubview(subview)
    end
    
    view.contentSize = CGSizeMake(view.frame.size.width, ItemHeight * colors.size);
  end
  
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
  end
end
