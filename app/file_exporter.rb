class FileExporter

  def initialize(data_store)
    @data_store = data_store
  end

  def export_to_temp_file
    dirURL = NSFileManager.defaultManager.URLForDirectory(NSItemReplacementDirectory, inDomain:NSUserDomainMask, appropriateForURL:NSURL.fileURLWithPath("fv"), create:true, error:nil)
    tmpDir = dirURL.path

    #make a file name to write the data to using the documents directory:
    fileName = "#{tmpDir}/textfile.txt"
    
    content = ""
    @data_store.tasks.each do |task|
      if task.dotted?
        content << "* "
      else
        content << "  "
      end
      
      content << task.text << "\n"
    end
        
    #save content to the documents directory
    content.writeToFile(fileName, atomically:false, encoding:NSStringEncodingConversionAllowLossy, error:nil)

    fileName
  end  
  
end