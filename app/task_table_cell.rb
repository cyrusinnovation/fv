class TaskTableCell < UITableViewCell
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      taskViewFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)
      taskView = UIView.alloc.initWithFrame(taskViewFrame)
      taskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      @textLabel = UILabel.alloc.initWithFrame(taskViewFrame)
      @textLabel.backgroundColor = UIColor.redColor
      taskView.addSubview(@textLabel)
      self.contentView.addSubview(taskView)
    end
    self
  end
  
  def taskText=taskText
    @textLabel.text = taskText
  end
  
end
