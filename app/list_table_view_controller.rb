class ListTableViewController < UITableViewController
  RegCount = 20
  
  def viewDidLoad
    view.dataSource = self
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'handlePlusClicked')
  end
  
  def handlePlusClicked
    indexPath = NSIndexPath.indexPathForRow(RegCount, inSection:0)
    view.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPositionBottom, animated:false)
    
    # This is null if above is animated
    cell = view.cellForRowAtIndexPath(indexPath)
    cell.contentView.subviews[0].becomeFirstResponder
  end
    
  # Required method of UITableViewDataSource
  def tableView(tableView, numberOfRowsInSection:section)
    section == 0 ? RegCount + 1 : 0
  end
  
  EntryCellID = 'A'
  TaskCellID = 'B'
  # Required method of UITableViewDataSource
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if indexPath.row < RegCount
      cell = tableView.dequeueReusableCellWithIdentifier(TaskCellID) || begin
        TaskTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:TaskCellID)
      end
      cell.text = "Cell #{indexPath.row}"
      return cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier(EntryCellID) || begin
        EntryTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:EntryCellID)
      end
      return cell
    end
  end
  
end
