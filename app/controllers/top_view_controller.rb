class TopViewController < UIViewController
  include Notifications
  
  def initWithStore(task_store)
    if init
      @task_store = task_store

      @tasks = @task_store.tasks
      @selected_indexes = []
      @tasks.each_index do |index|
        task = @tasks[index]
        if task.dotted?
          @selected_indexes << index
        end
      end
      @selected_indexes.reverse!
    end
    self
  end

  def loadView
    self.view = TopView.alloc.initWithFrame(CGRectMake(0,0,UIScreen.mainScreen.applicationFrame.size.width,TaskListView::TaskHeight))
    @task_view = TaskView.alloc.initWithFrame(self.view.frame)
    @task_view.hidden = true
    view.addSubview(@task_view)
    observe(ScrollViewMovedNotification, action:'handleScrollViewMoved')
  end

  def handleScrollViewMoved(notification)
    y_offset = notification.object.view.contentOffset.y
    logical_y = (y_offset / TaskListView::TaskHeight).floor
    show_this = @selected_indexes.find { |index| index <= logical_y }
    
    if show_this.nil?
      @task_view.hidden = true
    else
      task = @tasks[show_this]
      @task_view.update_task(task,42)
      @task_view.hidden = false
    end
  end


end