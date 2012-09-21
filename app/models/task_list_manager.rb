class TaskListManager
  
  def self.shared
    @instance ||= TaskListManager.new
  end
  
  def task_store
    @task_store
  end
  
  private
  
  def initialize
    @task_store = TaskStore.shared
  end
  
end