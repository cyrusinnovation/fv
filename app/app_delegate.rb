class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(MyTableViewController.alloc.init)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end

class MyTableViewController < UITableViewController
  
  def viewDidLoad
    view.dataSource = self
  end
  
  # Required method of UITableViewDataSource
  def tableView(tableView, numberOfRowsInSection:section)
    section == 0 ? 20 : 0
  end
  
  CellID = 'Foo'
  
  # Required method of UITableViewDataSource
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    end
    cell.textLabel.text = "Cell #{indexPath.row}"
    cell
  end
  
end