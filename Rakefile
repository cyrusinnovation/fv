$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'fv'

  app.files_dependencies 'app/dropbox_service.rb' => 'app/notifications.rb'
  app.files_dependencies 'app/export_view_controller.rb' => 'app/notifications.rb'


  app.frameworks += ['CoreData','Security','QuartzCore']
  app.vendor_project('vendor/DropboxSDK.framework', :static, :products => ['DropboxSDK'], :headers_dir => 'Headers')    


  # <key>CFBundleURLTypes</key>
  # <array>
  #     <dict>
  #         <key>CFBundleURLSchemes</key>
  #         <array>
  #             <string>db-APP_KEY</string>
  #         </array>
  #     </dict>
  # </array>
  app.info_plist['CFBundleURLTypes'] = [{
    'CFBundleURLSchemes' => ['db-ttgx76yturz2rqt']
  }]

end
