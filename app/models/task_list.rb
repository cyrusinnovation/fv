class TaskList
  TaskListCollapsedNotification = 'TaskListCollapsed'
  TaskListExpandedNotification = 'TaskListExpanded'
  TaskListChangedNotification = 'TaskListChanged'

  def self.shared
    @instance ||= TaskList.new
  end
  
  def tasks
    all_tasks = TaskStore.shared.all_tasks
    @collapsed ? all_tasks.select { |task| task.dotted? } : all_tasks
  end

  def add_text_task(text)
    return if text == ''
    TaskStore.shared.create_task do |task|
      task.date_moved = NSDate.date
      task.text = text
      task.dotted = false
      task.active = false
      task.photo = false
    end
    ensure_correctness
    App.notification_center.post(TaskListChangedNotification)
  end
  
  def add_photo_task(image)
    TaskStore.shared.create_task do |task|
      task.date_moved = NSDate.date
      task.dotted = false
      task.active = false
      task.photo = true
      task.photo_uuid = CFUUIDCreateString(KCFAllocatorDefault, CFUUIDCreate(KCFAllocatorDefault))
      scaled_image = ImageStore.saveImage(image, forTask:task)
      task.photo_width = scaled_image.size.width
      task.photo_height = scaled_image.size.height
    end
    ensure_correctness
    App.notification_center.post(TaskListChangedNotification)
  end
  
  def remove_task(taskID)
    TaskStore.shared.delete_task(taskID) do |task|
      ImageStore.deleteImageForTask(task) if task.photo?
    end
    ensure_correctness
    App.notification_center.post(TaskListChangedNotification)
  end

  def toggle_dotted(taskID)
    TaskStore.shared.update_task(taskID) do |task|
      if task.dotted?
        task.dotted = false
        task.active = false
      else
        task.dotted = true
      end
    end
    ensure_correctness
    App.notification_center.post(TaskListChangedNotification)
  end
  
  def pause_task(taskID)
    TaskStore.shared.update_task(taskID) do |task|
      task.dotted = false
      task.date_moved = NSDate.date
    end
    ensure_correctness
    App.notification_center.post(TaskListChangedNotification)
  end
  
  def collapse
    @collapsed = true
    App.notification_center.post(TaskListCollapsedNotification)
    App.notification_center.post(TaskListChangedNotification)
  end
  
  def expand
    @collapsed = false
    App.notification_center.post(TaskListExpandedNotification)
    App.notification_center.post(TaskListChangedNotification)
  end

  def compose_mail(picker)
    message = ""
    tasks.each do |task|
      message << (task.dotted? ? "* " : "  ")
      if task.photo?
        message << "[photo]" << "\n"
      else
        message << task.text << "\n"
      end
    end
    subject = "fv list"

    picker.setSubject(subject)
    picker.setMessageBody(message,isHTML:false)
  end
  

  private

  def ensure_correctness
    TaskStore.shared.update_tasks do |tasks|
      return if tasks.empty?
      tasks.first.dotted = true
      tasks.each { |task| task.active = false }
      tasks.reverse.find { |task| task.dotted? }.active = true
    end
  end
  
  
end