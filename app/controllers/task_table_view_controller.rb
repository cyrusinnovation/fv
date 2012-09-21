class TaskTableViewController < UITableViewController

  def viewDidLoad
    view.dataSource = self
    view.delegate = self
    TaskStore::AllChangeNotifications.each do |event|
      App.notification_center.observe(event) do |notification|
        view.reloadData
      end
    end
  end
  
  def didMoveToParentViewController(parentController)
    view.frame = CGRectMake(0,0,parentController.view.frame.size.width,parentController.view.frame.size.height)
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    TaskStore.shared.tasks.size
  end

  PHOTOCELLID = 'PhotoCell'
  TEXTCELLID = "TextCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    task = TaskStore.shared.tasks[indexPath.row]
    
    if task.photo?
      cell = tableView.dequeueReusableCellWithIdentifier(PHOTOCELLID) || begin
        cell = PhotoTaskTableCell.alloc.initWithIdentifier(PHOTOCELLID)
        cell
      end
    else
      cell = tableView.dequeueReusableCellWithIdentifier(TEXTCELLID) || begin
        cell = TextTaskTableCell.alloc.initWithIdentifier(TEXTCELLID)
        cell
      end
    end
      
    cell.task = task
    cell
  end
  
  TextCellHeight = 69
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    task = TaskStore.shared.tasks[indexPath.row]
    
    height = task.photo? ? (task.photo_height / UIScreen.mainScreen.scale) : TextCellHeight
  end
  
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.updateBackgroundColor
  end
  
  
end