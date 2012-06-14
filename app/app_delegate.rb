class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    tab_controller = UITabBarController.alloc.init
    task_view_controller = TaskViewController.alloc.initWithStore(TaskStore.alloc.init)
    task_view_controller.title = 'Tasks'
    export_view_controller = ExportViewController.alloc.init
    export_view_controller.title = 'Export'
    tab_controller.viewControllers = [task_view_controller, export_view_controller]
    @window.rootViewController = tab_controller

    @window.makeKeyAndVisible
    true
  end
end
