$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'fv'
  app.frameworks += ['CoreData', 'MessageUI']

  app.files_dependencies 'app/models/task_store.rb' => 'app/notifications.rb'
  app.files_dependencies 'app/controllers/task_view_controller.rb' => 'app/notifications.rb'
  app.files_dependencies 'app/controllers/task_list_view_controller.rb' => 'app/notifications.rb'

end
