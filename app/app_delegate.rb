class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    
    @task_store = TaskStore.new
    @dropbox_service = DropboxFoo.new

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    tab_controller = UITabBarController.alloc.init
    task_view_controller = TaskViewController.alloc.initWithStore(@task_store)
    file_exporter = FileExporter.new(@task_store)
    export_view_controller = ExportViewController.alloc.initWithDropboxFoo(@dropbox_service, file_exporter:file_exporter)
    
    tab_controller.viewControllers = [task_view_controller, export_view_controller]

    @window.rootViewController = tab_controller
    @window.makeKeyAndVisible
    true
  end
  
  def application(application, handleOpenURL:url)
    return @dropbox_service.handleOpenURL(url)
  end

  
end
