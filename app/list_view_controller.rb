class ListViewController < UIViewController
  ItemHeight = 200
  
  def loadView
    self.view = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    redView = UIView.alloc.initWithFrame(CGRectMake(0,0,view.frame.size.width, ItemHeight))
    redView.backgroundColor = UIColor.redColor
    view.addSubview(redView)

    blueView = UIView.alloc.initWithFrame(CGRectMake(0,ItemHeight,view.frame.size.width, ItemHeight))
    blueView.backgroundColor = UIColor.blueColor
    view.addSubview(blueView)

    greenView = UIView.alloc.initWithFrame(CGRectMake(0,ItemHeight * 2,view.frame.size.width, ItemHeight))
    greenView.backgroundColor = UIColor.greenColor
    
    recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:"greenTapped")
    
    greenView.addGestureRecognizer(recognizer)
    view.addSubview(greenView)
    

    yellowView = UIView.alloc.initWithFrame(CGRectMake(0,ItemHeight * 3,view.frame.size.width, ItemHeight))
    yellowView.backgroundColor = UIColor.yellowColor
    view.addSubview(yellowView)

    
    view.contentSize = CGSizeMake(view.frame.size.width, ItemHeight * 4);
  end
  
  def greenTapped
    puts "foo"
  end
  
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
  end
end
