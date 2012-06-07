class TaskView < UIView
  include Notifications
  
  def initWithFrame(frame, task:task)
    if initWithFrame(frame)
      @label = UILabel.alloc.initWithFrame(CGRectMake(0,0, frame.size.width, frame.size.height))
      addSubview(@label)
      update(task)
      addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action:"handleTap"))
      addGestureRecognizer(UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handleSwipe"))
    end
    self
  end

  def update(task)
    @taskID = task.objectID
    @label.text = task.text
    if task.dotted?
      @label.backgroundColor = UIColor.grayColor
    else
      @label.backgroundColor = UIColor.whiteColor
    end
  end

  def handleTap
    TaskStore.shared.toggle_dotted(@taskID)
  end
  
  def handleSwipe
    TaskStore.shared.remove_task(@taskID)
  end
  
  def taskID
    @taskID
  end
end