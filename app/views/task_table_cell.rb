class TaskTableCell < UITableViewCell

  def initWithIdentifier(reuseIdentifier)
    initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:reuseIdentifier)
    when_tapped { TaskList.shared.toggle_dotted(taskID) }
    when_swiped_right { TaskList.shared.remove_task(taskID) if @active }
    when_swiped_left { TaskList.shared.pause_task(taskID) if @active }
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