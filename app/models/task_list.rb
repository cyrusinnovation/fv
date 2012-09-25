class TaskList
  TaskListChangedNotification = 'TaskListChanged'

  def self.shared
    @instance ||= TaskList.new
  end
  
  def initialize
    @task_store = TaskStore.shared
  end
  
  def all_tasks
    @task_store.all_tasks
  end

  def add_text_task(text)
    make_change do
      return if text == ''
      @task_store.create_task do |task|
        task.date_moved = NSDate.date
        task.text = text
        task.dotted = false
        task.active = false
        task.photo = false
      end
    end
  end
  
  def add_photo_task(image)
    make_change do
      @task_store.create_task do |task|
        task.date_moved = NSDate.date
        task.dotted = false
        task.active = false
        task.photo = true
        task.photo_uuid = BubbleWrap.create_uuid
        scaled_image = ImageStore.saveImage(image, forTask:task)
        task.photo_width = scaled_image.size.width
        task.photo_height = scaled_image.size.height
      end
    end
  end
  
  def remove_task(taskID)
    make_change do
      @task_store.delete_task(taskID) do |task|
        ImageStore.deleteImageForTask(task) if task.photo?
      end
    end
  end

  def toggle_dotted(taskID)
    make_change do
      @task_store.update_task(taskID) do |task|
        if task.dotted?
          task.dotted = false
          task.active = false
        else
          task.dotted = true
        end
      end
    end
  end
  
  def pause_task(taskID)
    make_change do
      @task_store.update_task(taskID) do |task|
        task.dotted = false
        task.date_moved = NSDate.date
      end
    end
  end
  
  private
  
  def make_change(&proc)
    proc.call
    ensure_correctness
    App.notification_center.post(TaskListChangedNotification)
  end

  def ensure_correctness
    @task_store.update_tasks do |tasks|
      return if tasks.empty?
      tasks.first.dotted = true
      tasks.each { |task| task.active = false }
      tasks.reverse.find { |task| task.dotted? }.active = true
    end
  end
  
  
end