class TaskListView < UIScrollView

  
  def drawTasks(tasks)
    total_height = 0
    tasks.each_index do |index|
      task = tasks[index]
      subview = TaskView.alloc.initWithTask(task, andY:total_height)
      self.addSubview(subview)
      total_height += subview.frame.size.height
    end
    self.contentSize = CGSizeMake(self.frame.size.width, total_height)

  end
  
  def redraw_tasks(tasks)
    self.subviews.each do |task_view|
      task_view.removeFromSuperview
    end
    self.drawTasks(tasks)
  end
  
end