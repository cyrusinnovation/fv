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
    yoffset = scrollView.contentOffset.y
    
    @selected_indexes.each do |index|
      subview = @task_views[index]
      if yoffset > TaskHeight * index
        newFrame = CGRectMake(0,yoffset,scrollView.frame.size.width,TaskHeight)
        subview.frame = newFrame
      else
        newFrame = CGRectMake(0,TaskHeight * index,scrollView.frame.size.width,TaskHeight)
        subview.frame = newFrame
      end
    end    
    
  end

  def drawTasks
    @task_views = []
    @selected_indexes = []
    TaskStore.shared.tasks.each_index do |index|
      task = TaskStore.shared.tasks[index]
      subview = task_view(index, task)
      @task_views << subview
      view.addSubview(subview)
      if task.dotted?
        @selected_indexes << index
      end
    end
    
    @selected_indexes.each do |index|
      view.bringSubviewToFront(@task_views[index])
    end
  end
  
  def task_view(index, task)
    task_frame = CGRectMake(0, TaskHeight * index, view.frame.size.width, TaskHeight)
    task_view = UIView.alloc.initWithFrame(task_frame)
    task_label = UILabel.alloc.initWithFrame(CGRectMake(0,0, task_view.frame.size.width, task_view.frame.size.height))
    task_label.text = task.text
    task_view.addSubview(task_label)
    if task.dotted?
      task_label.backgroundColor = UIColor.grayColor
    end
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