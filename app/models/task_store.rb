class TaskStore

  def self.shared
    @instance ||= TaskStore.new
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
    
    @collapsed = false
  end
  
  def all_tasks
    @all_tasks ||= load_tasks
  end
  
  def create_task
    task = NSEntityDescription.insertNewObjectForEntityForName('Task', inManagedObjectContext:@context)
    yield task
    do_save
  end
  
  def delete_task(taskID)
    task = @context.objectWithID(taskID)
    yield task
    @context.deleteObject(task)
    do_save
  end
  
  def update_task(taskID)
    task = @context.objectWithID(taskID)
    yield task
    do_save
  end
  
  def update_tasks
    @all_tasks = load_tasks
    yield @all_tasks
    do_save
  end

  private
  
  def do_save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
  end
  
  def load_tasks
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

