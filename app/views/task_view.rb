class TaskView < UIView
  include Notifications
  Padding = 5
  TaskHeight = 69
  
  
  
  def initWithTask(task, andY:y)
    height = task.photo? ? (task.photo_height / UIScreen.mainScreen.scale) : TaskHeight
    task_frame = CGRectMake(0, y, UIScreen.mainScreen.applicationFrame.size.width, height)
    if initWithFrame(task_frame)
      addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action:"handleTap"))
      addGestureRecognizer(UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handleRightSwipe"))
      leftRecognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handleLeftSwipe")
      leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft
      addGestureRecognizer(leftRecognizer)
      update_task(task)
    end
    self
  end

  def update_task(task)
    @taskID = task.objectID
    if (task.photo?)
      image = ImageStore.imageForTask(task)
      imageView = UIImageView.alloc.initWithImage(image.sepia, highlightedImage:image)
      imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
      self.backgroundColor = background_color(task)
      imageView.highlighted = task.dotted?
      addSubview(imageView)
    else
      label = UILabel.alloc.initWithFrame(CGRectMake(Padding,0, frame.size.width - (Padding * 2), frame.size.height - 1))
      label.text = task.text
      label.backgroundColor = self.backgroundColor = background_color(task)
      addSubview(label)
    end
    @active = task.active?
  end

  def handleTap
    publish(TaskViewTapNotification)
  end
  
  def handleRightSwipe
    publish(TaskViewRightSwipeNotification) if @active
  end
  
  def handleLeftSwipe
    publish(TaskViewLeftSwipeNotification) if @active
  end
  
  def taskID
    @taskID
  end
    
  private 
  
  def background_color(task)
    return UIColor.redColor if task.active?
    return UIColor.grayColor if task.dotted?
    return UIColor.whiteColor
  end
end