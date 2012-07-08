$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'fv'
  app.frameworks += ['CoreData', 'MessageUI']

  app.pods do
    dependency 'NYXImagesKit'
  end

  [
    'app/models/task_store.rb', 
    'app/controllers/add_task_view_controller.rb',
    'app/controllers/task_view_controller.rb',
    'app/controllers/task_list_view_controller.rb',
    'app/controllers/pull_tab_view_controller.rb'
  ].each do |file|
     app.files_dependencies file => 'app/notifications.rb' 
  end


end
