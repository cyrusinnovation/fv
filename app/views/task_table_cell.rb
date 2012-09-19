class TaskTableCell < UITableViewCell

  TaskViewTapNotification = 'TaskViewTap'
  TaskViewRightSwipeNotification = 'TaskViewRightSwipe'
  TaskViewLeftSwipeNotification = 'TaskViewLeftSwipe'

  def initWithIdentifier(reuseIdentifier)
    initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:reuseIdentifier)
    whenTapped do
      App.notification_center.post(TaskViewTapNotification, self)
    end
    whenSwipedRight do
      App.notification_center.post(TaskViewRightSwipeNotification, self) if @active
    end
    whenSwipedLeft do
      App.notification_center.post(TaskViewLeftSwipeNotification, self) if @active
    end
    self
  end
  
  def task= task
    @taskID = task.objectID
    @active = task.active?
    @dotted = task.dotted?
    update_task_content(task)
  end
  
  def updateBackgroundColor
    contentView.backgroundColor = textLabel.backgroundColor = compute_background_color
  end
  
  def taskID
    @taskID
  end
  
  private

  def compute_background_color
    return UIColor.redColor if @active
    return UIColor.grayColor if @dotted
    return UIColor.whiteColor
  end

end

class PhotoTaskTableCell < TaskTableCell

  def update_task_content(task)
    image = ImageStore.imageForTask(task)
    imageView = UIImageView.alloc.initWithImage(image.sepia, highlightedImage:image)
    imageView.highlighted = task.dotted?

    contentView.subviews[0].removeFromSuperview unless contentView.subviews.empty?
    
    contentView.addSubview(imageView)
  end
  
end

class TextTaskTableCell < TaskTableCell

  def update_task_content(task)
    textLabel.text = task.text
  end
  
end