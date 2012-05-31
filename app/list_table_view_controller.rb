class ListTableViewController < UITableViewController
  
  def viewDidLoad
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'handlePlusClicked')

    @view_toggle = UISegmentedControl.alloc.initWithItems(["All","Selected"])
    @view_toggle.selectedSegmentIndex = 0
    view.dataSource = AllStrategy.shared
    navigationItem.titleView = @view_toggle
    @view_toggle.addTarget(self, action:'handleViewToggleChange', forControlEvents:UIControlEventValueChanged)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'handleTaskListUpdated:', name:'textFieldDoneEditing', object:nil)
  end
  
  def handleViewToggleChange
    
    if @view_toggle.selectedSegmentIndex == 0 # "All"
      view.dataSource = AllStrategy.shared
    else
      view.dataSource = SelectedStrategy.shared
    end
    view.dataSource.transitionView(tableView)
  end
  
  def handleTaskListUpdated(notification)
    TaskStore.shared.add_task do |task|
      task.date_moved = NSDate.date
      task.text = notification.object
      task.dotted = false
    end
    view.reloadData
  end
  
  def handlePlusClicked
    indexPath = last_index_path
    view.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPositionBottom, animated:false)
    
    # This is null if above is animated
    cell = view.cellForRowAtIndexPath(indexPath)
    cell.contentView.subviews[0].becomeFirstResponder
  end
  
  private
  
  def last_index_path
    NSIndexPath.indexPathForRow(TaskStore.shared.tasks.size, inSection:0)
  end

  def tableView(tableView, willSelectRowAtIndexPath:indexPath)
    view.dataSource.tableView(tableView, willSelectRowAtIndexPath:indexPath)
  end
  
end

# needs to implement UITableViewDataSource
class AllStrategy
  def self.shared
    @shared ||= AllStrategy.new
  end

  # Required method of UITableViewDataSource
  def tableView(tableView, numberOfRowsInSection:section)
    TaskStore.shared.tasks.size + 1
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    indexPath.row < TaskStore.shared.tasks.size ? task_cell(tableView, indexPath) : input_cell(tableView, indexPath)
  end

  # A bit of a hack to put this here.
  def tableView(tableView, willSelectRowAtIndexPath:indexPath)
    task = TaskStore.shared.tasks[indexPath.row]
    TaskStore.shared.toggle_dotted(task)
    tableView.reloadData
    nil
  end
  
  def transitionView(tableView)
    tableView.reloadData
  end

  private
  
  TaskCellId = 'A'
  def task_cell(tableView, indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(TaskCellId) || begin
      TaskTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:TaskCellId)
    end
    task = TaskStore.shared.tasks[indexPath.row]
    cell.task = task
    cell
  end

  EntryCellID = 'B'
  def input_cell(tableView, indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(EntryCellID) || begin
      EntryTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:EntryCellID)
    end
    cell
  end

end

# needs to implement UITableViewDataSource
class SelectedStrategy
  
  def self.shared
    @shared ||= SelectedStrategy.new
  end

  # Required method of UITableViewDataSource
  def tableView(tableView, numberOfRowsInSection:section)
    TaskStore.shared.dotted_tasks.size + 1
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    indexPath.row < TaskStore.shared.dotted_tasks.size ? task_cell(tableView, indexPath) : input_cell(tableView, indexPath)
  end

  # A bit of a hack to put this here.
  def tableView(tableView, willSelectRowAtIndexPath:indexPath)
    # Selecting does nothing in this "view"
    nil
  end
  
  def transitionView(tableView)
    tableView.reloadData
  end
  

  private
  
  TaskCellId = 'A'
  def task_cell(tableView, indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(TaskCellId) || begin
      TaskTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:TaskCellId)
    end
    task = TaskStore.shared.dotted_tasks[indexPath.row]
    cell.task = task
    cell
  end

  EntryCellID = 'B'
  def input_cell(tableView, indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(EntryCellID) || begin
      EntryTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:EntryCellID)
    end
    cell
  end
  
end
