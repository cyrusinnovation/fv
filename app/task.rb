class Task < NSManagedObject
  def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = 'Task'
      entity.managedObjectClassName = 'Task'
      entity.properties = ['dotted', NSBooleanAttributeType,
          'date_moved', NSDateAttributeType,
          'text', NSStringAttributeType].each_slice(2).map do |name, type|
            property = NSAttributeDescription.alloc.init
            property.name = name
            property.attributeType = type
            property.optional = false
            property
          end
      entity
    end
  end
end