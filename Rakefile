$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'
require 'bubble-wrap'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'fv'
  app.frameworks += ['CoreData', 'MessageUI']

  app.pods do
    dependency 'NYXImagesKit'
  end
  
  app.codesign_certificate = 'iPhone Distribution: Cyrus Innovation'
  app.identifier = 'com.cyrusinnovation.fv'
  # Fix the path and add the correct mobileprovision file for your computer
  # app.provisioning_profile = '/Users/alg/Library/MobileDevice/Provisioning Profiles/68881993-40CD-47DC-9B7D-5BE653945D66.mobileprovision'
   app.provisioning_profile = '/Users/paul/Library/MobileDevice/Provisioning Profiles/F5F8BAA2-7CF8-4B2F-8A9F-EC4313D1804A.mobileprovision'
end
