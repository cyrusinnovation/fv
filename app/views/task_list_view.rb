class TaskListView < UIScrollView
  TaskHeight = 69
  
  def drawTasks(tasks)
    self.contentSize = CGSizeMake(self.frame.size.width, tasks.size * TaskHeight)
    tasks.each_index do |index|
      task = tasks[index]
      task_frame = CGRectMake(0, TaskHeight * index, self.frame.size.width, TaskHeight)
      subview = TaskView.alloc.initWithFrame(task_frame)
      subview.update_task(task,index)
      self.addSubview(subview)
    end

  end
  
  def redraw_tasks(tasks)
    tasks = @collapsed ? tasks.select { |task| task.dotted? } : tasks
    self.subviews.each do |task_view|
      task_view.removeFromSuperview
    end
    self.drawTasks(tasks)
  end
  

  
end