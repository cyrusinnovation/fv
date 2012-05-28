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
  RegCount = 20
  
  def viewDidLoad
    view.dataSource = self
  end
  
  # Required method of UITableViewDataSource
  def tableView(tableView, numberOfRowsInSection:section)
    section == 0 ? RegCount + 1 : 0
  end
  
  CellID = 'Foo'
  AnotherCellID = 'Bar'
  # Required method of UITableViewDataSource
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if indexPath.row < RegCount
      cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
        RegularTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
      end
      cell.text = "Cell #{indexPath.row}"
      return cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier(AnotherCellID) || begin
        TextEntryTableCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:AnotherCellID)
      end
      return cell
    end
  end
  
end

class TextEntryTableCell < UITableViewCell
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      taskViewFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)
      textField = UITextField.alloc.initWithFrame(taskViewFrame)
      textField.delegate = self
      textField.backgroundColor = UIColor.greenColor
      textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      self.contentView.addSubview(textField)
    end
    self
  end
  
  # Defined for UITextFieldDelegate
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    return true
  end
  
  
end


class RegularTableCell < UITableViewCell
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      taskViewFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)
      taskView = UIView.alloc.initWithFrame(taskViewFrame)
      taskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      @textLabel = UILabel.alloc.initWithFrame(taskViewFrame)
      @textLabel.backgroundColor = UIColor.redColor
      taskView.addSubview(@textLabel)
      self.contentView.addSubview(taskView)
    end
    self
  end
  
  def text=text
    @textLabel.text = text
  end
  
end

