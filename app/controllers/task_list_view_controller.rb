class TaskListViewController < UIViewController

  def initWithStore(task_store)
    if init
      @task_store = task_store
    end
    self
  end
  
  def didMoveToParentViewController(parentController)
    view.frame = CGRectMake(0,0,parentController.view.frame.size.width,parentController.view.frame.size.height)
  end

  def loadView
    self.view = TaskListView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)

    TaskStore::AllChangeNotifications.each do |event|
      App.notification_center.observe(event) do |notification|
        view.redraw_tasks(@task_store.tasks)
      end
    end
    
    view.drawTasks(@task_store.tasks)
  end
  
end