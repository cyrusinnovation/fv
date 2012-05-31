class TaskTableCell < UITableViewCell  
  def task=task
    self.text = task.text
    self.contentView.backgroundColor = task.dotted? ? UIColor.blueColor : UIColor.whiteColor
  end
end
