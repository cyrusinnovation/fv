class ImageStore
  
  def self.saveImage(image, forTask:task)

    scaleFactor = scaleFactorForImage(image)
    newSize = CGSizeMake(image.size.width * scaleFactor, image.size.height * scaleFactor)
    UIGraphicsBeginImageContext(newSize)
    image.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
    newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()    
    pngData = NSData.dataWithData(UIImagePNGRepresentation(newImage))
    pngData.writeToFile(pathForTask(task), atomically:true)
    newImage
  end

  def self.imageForTask(task)
    imagePath = pathForTask(task)
    UIImage.imageWithContentsOfFile(imagePath)
  end
  
  def self.deleteImageForTask(task)
    imagePath = pathForTask(task)
    NSFileManager.defaultManager.removeItemAtPath(imagePath, error:nil)
  end

  private
  
  def self.scaleFactorForImage(image)
    screenWidth = UIScreen.mainScreen.bounds.size.width * UIScreen.mainScreen.scale
    scaleFactor = screenWidth / image.size.width
    scaleFactor
  end
  
  def self.pathForTask(task)
    docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
    filename = "#{docDir}/#{task.photo_uuid}.png"
  end
  
end




