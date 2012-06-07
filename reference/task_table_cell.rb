class TaskTableCell < UITableViewCell  
  Light_Blue = UIColor.colorWithRed(164.0/255.0, green:209.0/255.0, blue:237.0/255.0, alpha:1.0)

  def task=task
    @task = task
    textLabel.text = task.text
    contentView.backgroundColor = textLabel.backgroundColor = task.dotted? ? Light_Blue : UIColor.whiteColor
  end
  
  def task
    @task
  end
  
end
