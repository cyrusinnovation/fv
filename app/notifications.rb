module Notifications
  AddTappedNotification = 'AddTapped'
  EmailTappedNotification = 'EmailTapped'

  TaskAddedNotification = 'TaskAdded'
  TaskChangedNotification = 'TaskChanged'
  TaskRemovedNotification = 'TaskRemoved'
  TaskPausedNotification = 'TaskPaused'

  TaskViewTapNotification = 'TaskViewTap'
  TaskViewRightSwipeNotification = 'TaskViewRightSwipe'
  TaskViewLeftSwipeNotification = 'TaskViewLeftSwipe'

  def observe(notificationName, action:handler)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:"#{handler}:", name:notificationName, object:nil)
  end
  
  def publish(notificationName)
    NSNotificationCenter.defaultCenter.postNotificationName(notificationName, object:self)
  end
  
end