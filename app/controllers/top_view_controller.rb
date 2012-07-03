class TopViewController < UIViewController
  include Notifications
  
  def initWithStore(task_store)
    if init
      @task_store = task_store
      update_indexes
      @last_y_offset = 0
      # Observe model changes.
      observe(TaskAddedNotification, action:'handleModelChange')
      observe(TaskChangedNotification, action:'handleModelChange')
      observe(TaskRemovedNotification, action:'handleModelChange')
      observe(TaskPausedNotification, action:'handleModelChange')
      observe(TaskListCollapsedNotification, action:'handleModelChange')
      observe(TaskListExpandedNotification, action:'handleModelChange')
    end
    self
  end

  def loadView
    self.view = TopView.alloc.initWithFrame(CGRectMake(0,0,UIScreen.mainScreen.applicationFrame.size.width,TaskListView::TaskHeight))
    @task_view = TaskView.alloc.initWithFrame(self.view.frame)
    @task_view.hidden = true
    view.addSubview(@task_view)
    observe(ScrollViewMovedNotification, action:'handleScrollViewMoved')
    update_for_yoffset(@last_y_offset)
  end

  def handleScrollViewMoved(notification)
    y_offset = notification.object.view.contentOffset.y
    update_for_yoffset(y_offset)
  end
  
  def handleModelChange(notification)
    update_indexes
    update_for_yoffset(@last_y_offset)
  end

  private
  
  def update_for_yoffset(y_offset)
    @last_y_offset = y_offset

    row_index = (y_offset / TaskListView::TaskHeight).floor
    closest_dotted_task_index = @dotted_indexes.find { |index| index <= row_index }
    
    if closest_dotted_task_index.nil?
      @task_view.hidden = true
    else
      task = @tasks[closest_dotted_task_index]
      @task_view.update_task(task)

      closest_dotted_task_index_for_next_row = @dotted_indexes.find { |index| index <= (row_index + 1) }
      is_rolling = closest_dotted_task_index_for_next_row != closest_dotted_task_index

      new_y = is_rolling ? -(y_offset % TaskListView::TaskHeight) : 0

      @task_view.frame = CGRectMake(0, new_y, @task_view.frame.size.width, @task_view.frame.size.height)
      @task_view.hidden = false
    end
  end
  
  
  def update_indexes
    @tasks = @task_store.tasks
    @dotted_indexes = []
    @tasks.each_index do |index|
      task = @tasks[index]
      if task.dotted?
        @dotted_indexes << index
      end
    end
    @dotted_indexes.reverse!
  end

end