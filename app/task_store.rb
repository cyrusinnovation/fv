class TaskStore
  include Notifications
  
  def tasks
    @tasks ||= begin
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Task', inManagedObjectContext:@context)
      request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('date_moved', ascending:true)]

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end
  
  def add_task(text)
    return if text == ''

    task = NSEntityDescription.insertNewObjectForEntityForName('Task', inManagedObjectContext:@context)
    task.date_moved = NSDate.date
    task.text = text
    task.dotted = false
    save
    publish(TaskAddedNotification)
  end
  
  def remove_task(taskID)
    task = @context.objectWithID(taskID)
    @context.deleteObject(task)
    save
    publish(TaskRemovedNotification)
  end
  
  def pause_task(taskID)
    task = @context.objectWithID(taskID)
    task.dotted = 0
    task.date_moved = NSDate.date
    save
    publish(TaskPausedNotification)
  end
  
  def toggle_dotted(taskID)
    task = @context.objectWithID(taskID)
    if task.dotted?
      task.dotted = 0
    else
      task.dotted = 1
    end
    save
    publish(TaskChangedNotification)
  end
  
  def initialize
    model = NSManagedObjectModel.alloc.init
    model.entities = [Task.entity]
    
    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Tasks.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end
    
    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end

  private
  
  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @tasks = nil
  end
  
end