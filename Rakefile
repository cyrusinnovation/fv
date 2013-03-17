$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'fv'
  app.identifier = 'com.cyrusinnovation.fv'
  app.device_family = [:iphone]
  app.interface_orientations = [:portrait]
  
  app.frameworks += ['CoreData', 'MessageUI']

  app.pods do
    pod 'NYXImagesKit'
    pod 'TestFlightSDK'
  end
  
  app.development do
    app.provisioning_profile = 'provisioning/fv_development.mobileprovision'
    app.codesign_certificate = 'iPhone Distribution: Cyrus Innovation'

    app.testflight do
      app.entitlements['get-task-allow'] = false
      # API token for Paul Infield-Harm
      app.testflight.api_token = '0cad5085be5eb71b7b7ba9b10d3e4860_ODU1MDYzMjAxMy0wMS0zMCAxNToxNTo0My4xNzI1NjQ'
      # Team token for fv team
      app.testflight.team_token = '70cbd2240643514b41ecb8250320dab0_MjAwMjE5MjAxMy0wMy0xNyAxMjoxMDozNi40Mzc3ODU'
      # app token for fv app
      app.testflight.app_token = '9916ba70-58ac-4a56-aa5e-1b035ad7e146'
      app.testflight.distribution_lists = ['fv testers']
      app.testflight.notify = true
    end
  end
  
end
