class TaskTableViewController < UITableViewController

  def viewDidLoad
    view.dataSource = view.delegate = self
    view.allowsSelection = false
    App.notification_center.observe(TaskList::TaskListChangedNotification) { |event| view.reloadData }
    App.notification_center.observe(PullTabViewController::CollapseTappedNotification) { |event| collapse }
    App.notification_center.observe(PullTabViewController::ExpandTappedNotification) { |event| expand }
  end
  
  def didMoveToParentViewController(parentController)
    view.frame = CGRectMake(0,0,parentController.view.frame.size.width,parentController.view.frame.size.height)
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    tasks.size
  end

  PHOTOCELLID = 'PhotoCell'
  TEXTCELLID = "TextCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    task = tasks[indexPath.row]
    
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
    task = tasks[indexPath.row]
    height = task.photo? ? (task.photo_height / UIScreen.mainScreen.scale) : TextCellHeight
  end
  
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.updateBackgroundColor
  end

  def collapse
    @collapsed = true
    view.reloadData
  end
  
  def expand
    @collapsed = false
    view.reloadData
  end

  def tasks
    all_tasks = TaskList.shared.all_tasks
    @collapsed ? all_tasks.select { |task| task.dotted? } : all_tasks
  end
  
end