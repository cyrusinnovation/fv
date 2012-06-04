class TaskViewController < UIViewController
  TaskHeight = 50
  
  def loadView
    self.view = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    view.contentSize = CGSizeMake(view.frame.size.width, TaskStore.shared.tasks.size * TaskHeight)
    view.delegate = self
    view.backgroundColor = UIColor.redColor
    drawTasks
  end
  
  def scrollViewDidScroll(scrollView)
    # As currently designed, this is a display memory hog.
    # Here is where we would allocate or deallocate views based on the contentOffset
  end

  def drawTasks
    TaskStore.shared.tasks.each_index do |index|
      task = TaskStore.shared.tasks[index]
      view.addSubview(task_view(index, task))
    end
  end
  
  def task_view(index, task)
    task_frame = CGRectMake(0, TaskHeight * index, view.frame.size.width, TaskHeight)
    task_view = UIView.alloc.initWithFrame(task_frame)
    task_label = UILabel.alloc.initWithFrame(CGRectMake(0,0, task_view.frame.size.width, task_view.frame.size.height))
    task_label.text = task.text
    task_view.addSubview(task_label)
    task_view
  end


  def viewDidLoad
    @view_toggle = UISegmentedControl.alloc.initWithItems(["All","Selected"])
    @view_toggle.selectedSegmentIndex = 0
    navigationItem.titleView = @view_toggle
    @view_toggle.addTarget(self, action:'handleViewToggleChange', forControlEvents:UIControlEventValueChanged)
  end
  
  def handleViewToggleChange
    puts "toggled!"
  end
  
  
  
  
end