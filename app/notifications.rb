module Notifications
  AddTappedNotification = 'AddTapped'
  EmailTappedNotification = 'EmailTapped'
  CollapseTappedNotification = 'CollapseTapped'
  ExpandTappedNotification = 'ExpandTapped'

  TaskAddedNotification = 'TaskAdded'
  TaskChangedNotification = 'TaskChanged'
  TaskRemovedNotification = 'TaskRemoved'
  TaskPausedNotification = 'TaskPaused'

  TaskViewTapNotification = 'TaskViewTap'
  TaskViewRightSwipeNotification = 'TaskViewRightSwipe'
  TaskViewLeftSwipeNotification = 'TaskViewLeftSwipe'
  
  ScrollViewMovedNotification = 'ScrollViewMoved'

  def observe(notificationName, action:handler)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:"#{handler}:", name:notificationName, object:nil)
  end
  
  def publish(notificationName)
    NSNotificationCenter.defaultCenter.postNotificationName(notificationName, object:self)
  end
  
end