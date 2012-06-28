class TaskListView < UIScrollView
  TaskHeight = 40

  def initWithFrame(frame, taskStore:task_store)
    if initWithFrame(frame)
      @task_store = task_store
    end
    self
  end


  def drawTasks(tasks)
    self.contentSize = CGSizeMake(self.frame.size.width, tasks.size * TaskHeight)
    
    selected_indexes = []
    tasks.each_index do |index|
      task = tasks[index]
      if task.dotted?
        selected_indexes << index
      end
    end

    yoffset = self.contentOffset.y

    task_views = []
    tasks.each_index do |index|
      task = tasks[index]
      y = y_for_view(index, selected_indexes, yoffset)
      task_frame = CGRectMake(0, y, self.frame.size.width, TaskHeight)
      subview = TaskView.alloc.initWithFrame(task_frame, task:task, position:index)
      task_views << subview
      self.addSubview(subview)
    end
    
    selected_indexes.each do |index|
      self.bringSubviewToFront(task_views[index])
    end
    
    
    collect_adjust_data(tasks)

  end
  
  def y_for_view(index, selected_indexes, yoffset)
    
    # This is the position of the indexth view would
    # take if there wasn't any stickiness
    normal_pos = TaskHeight * index
    
    # position of index within list of selected indexes
    # nil if not present
    selected_index = selected_indexes.index(index)
    
    # If the selected_indexes doesn't contain index, then 
    # that view isn't one of a selected one.
    return normal_pos unless selected_index

    # If the normal position is far enough down then just put it in
    # its normal spot.
    return normal_pos if normal_pos > yoffset

    # Get the index into the list of views for the next selected view
    # if it exists
    next_selected = selected_indexes[selected_index + 1]

    if next_selected
      next_normal_pos = next_selected * TaskHeight
      
      # If the next selected is bumping into this one, get out of the way
      if next_normal_pos > yoffset && next_normal_pos < yoffset + TaskHeight
        return next_normal_pos - TaskHeight
      else
        return yoffset
      end
    else
      if yoffset > normal_pos 
        return yoffset
      else
        return normal_pos
      end
    end
  end


  def collect_adjust_data(tasks)
    @task_views_for_adjust = []
    self.subviews.each do |subview|
      @task_views_for_adjust[subview.position] = subview
    end

    @selected_indexes_for_adjust = []
    tasks.each_index do |index|
      task = tasks[index]
      if task.dotted?
        @selected_indexes_for_adjust << index
      end
    end
  end
  
  def adjust_selected
    yoffset = self.contentOffset.y
    
    @selected_indexes_for_adjust.each do |index|
      y = y_for_view(index, @selected_indexes_for_adjust, yoffset)
      @task_views_for_adjust[index].frame = CGRectMake(0,y,self.frame.size.width,TaskHeight)
    end    
  end
  
  def redraw_tasks(tasks)
    self.subviews.each do |task_view|
      task_view.removeFromSuperview
    end
    self.drawTasks(tasks)
  end
  
  
end