class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    tab_controller = UITabBarController.alloc.init
    task_view_controller = TaskViewController.alloc.initWithStore(TaskStore.alloc.init)
    task_view_controller.title = 'Tasks'
    dropbox_view_controller = DropboxViewController.alloc.init
    dropbox_view_controller.title = 'Dropbox'
    tab_controller.viewControllers = [task_view_controller, dropbox_view_controller]
    @window.rootViewController = tab_controller

    @window.makeKeyAndVisible
    true
  end
end
