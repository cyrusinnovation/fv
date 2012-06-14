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

    # Dropbox settings, likely can be done later.
    dbSession = DBSession.alloc.initWithAppKey("ttgx76yturz2rqt", appSecret:"hgasr9fz5g0r7no", root:"sandbox")
    DBSession.setSharedSession(dbSession)
    
    @window.makeKeyAndVisible
    true
  end
  
  def application(application, handleOpenURL:url)
    if DBSession.sharedSession.handleOpenURL(url)
      if DBSession.sharedSession.isLinked
        NSLog("App linked successfully! #{url}");
        # At this point you can start making API calls
      end
      return true;
    end
    # Add whatever other url handling code your app requires here
    return false;
  end

  
end
