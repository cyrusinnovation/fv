class NanoTaskStore

  def self.shared
    @instance ||= NanoTaskStore.new
  end
  
  def initialize
    @store = NanoTask.store = NanoStore.store(:file, App.documents_path + "/nano.db")
    @store.save_interval = 1000
  end
  
  def all_tasks
    @all_tasks ||= load_tasks
  end
  
  def create_task
    task = NanoTask.new
    yield task
    do_save
  end
  
  def delete_task(taskID)
    task = NanoTask.objectWithID(taskID)
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

