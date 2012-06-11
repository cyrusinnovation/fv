class TaskView < UIView
  include Notifications
  Padding = 5
  
  def initWithFrame(frame, task:task, position:position)
    if initWithFrame(frame)
      @label = UILabel.alloc.initWithFrame(CGRectMake(Padding,0, frame.size.width - (Padding * 2), frame.size.height - 1))
      addSubview(@label)
      update(task, position)
      addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action:"handleTap"))
    end
    self
  end

  def update(task, position)
    @taskID = task.objectID
    @label.text = task.text
    if task.dotted?
      @label.backgroundColor = self.backgroundColor = UIColor.grayColor
      addGestureRecognizer(UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handleRightSwipe"))
      leftRecognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handleLeftSwipe")
      leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft
      addGestureRecognizer(leftRecognizer)
    else
      @label.backgroundColor = self.backgroundColor = UIColor.whiteColor
    end
    @position = position
  end

  def handleTap
    publish(TaskViewTapNotification)
  end
  
  def handleRightSwipe
    publish(TaskViewRightSwipeNotification)
  end
  
  def handleLeftSwipe
    publish(TaskViewLeftSwipeNotification)
  end
  
  def taskID
    @taskID
  end
  
  def position
    @position
  end
end