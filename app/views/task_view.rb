class TaskView < UIView
  include Notifications
  Padding = 5
  
  def initWithFrame(frame)
    if super
      @label = UILabel.alloc.initWithFrame(CGRectMake(Padding,0, frame.size.width - (Padding * 2), frame.size.height - 1))
      addSubview(@label)
      addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action:"handleTap"))
      addGestureRecognizer(UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handleRightSwipe"))
      leftRecognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handleLeftSwipe")
      leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft
      addGestureRecognizer(leftRecognizer)
    end
    self
  end

  def update_task(task, position)
    @taskID = task.objectID
    @label.text = task.text
    @active = task.active?
    @position = position
    @label.backgroundColor = self.backgroundColor = background_color(task)
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
  
  def position
    @position
  end
  
  private 
  
  def background_color(task)
    return UIColor.redColor if task.active?
    return UIColor.grayColor if task.dotted?
    return UIColor.whiteColor
  end
end