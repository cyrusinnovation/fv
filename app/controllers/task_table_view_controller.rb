class TaskTableViewController < UITableViewController

  def viewDidLoad
    view.dataSource = self
    view.delegate = self
    App.notification_center.observe(TaskList::TaskListChangedNotification) do |event|
      view.reloadData
    end
  end
  
  def didMoveToParentViewController(parentController)
    view.frame = CGRectMake(0,0,parentController.view.frame.size.width,parentController.view.frame.size.height)
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    TaskList.shared.tasks.size
  end

  PHOTOCELLID = 'PhotoCell'
  TEXTCELLID = "TextCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    task = TaskList.shared.tasks[indexPath.row]
    
    if task.photo?
      cell = tableView.dequeueReusableCellWithIdentifier(PHOTOCELLID) || PhotoTaskTableCell.alloc.initWithIdentifier(PHOTOCELLID)
    else
      cell = tableView.dequeueReusableCellWithIdentifier(TEXTCELLID) || TextTaskTableCell.alloc.initWithIdentifier(TEXTCELLID)
    end
      
    cell.task = task
    cell
  end
  
  TextCellHeight = 69
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    task = TaskList.shared.tasks[indexPath.row]
    
    height = task.photo? ? (task.photo_height / UIScreen.mainScreen.scale) : TextCellHeight
  end
  
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.updateBackgroundColor
  end

end