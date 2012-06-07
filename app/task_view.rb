class TaskView < UIView
  def initWithFrame(frame, task:task)
    if initWithFrame(frame)
      label = UILabel.alloc.initWithFrame(CGRectMake(0,0, frame.size.width, frame.size.height))
      @task = task
      label.text = @task.text
      addSubview(label)
      if @task.dotted?
        label.backgroundColor = UIColor.grayColor
      end
    end
    self
  end
  
  def task
    @task
  end
end