class DropboxFoo
  include Notifications
  
  def initialize
    @dbSession = DBSession.alloc.initWithAppKey("ttgx76yturz2rqt", appSecret:"hgasr9fz5g0r7no", root:"sandbox")
  end
  
  def handleOpenURL(url)
    if @dbSession.handleOpenURL(url)
      if @dbSession.isLinked
        NSLog("App linked successfully! #{url}");
        # At this point you can start making API calls
      end
      return true;
    end
    # Add whatever other url handling code your app requires here
    return false;
  end

  def restClient
    @rest_client ||= begin
      rest_client = DBRestClient.alloc.initWithSession(@dbSession)
      rest_client.delegate = self
      rest_client
    end
  end

  def uploadFile(filename, toPath:destDir, fromPath:localPath, fromController:controller)
    @dbSession.linkFromController(controller) unless @dbSession.isLinked
    restClient.uploadFile(filename, toPath:destDir, withParentRev:nil, fromPath:localPath);
  end
  
  def restClient(client, uploadedFile:destPath, from:srcPath, metadata:metadata)
    publish(DropboxFileUploadedNotification)
  end

  def restClient(client, uploadFileFailedWithError:error)
    publish(DropboxFileUploadFailedNotification)
  end
  
end