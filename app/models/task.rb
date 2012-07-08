class Task < NSManagedObject
  def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = 'Task'
      entity.managedObjectClassName = 'Task'
      
      props = []
      props << property('dotted', NSBooleanAttributeType)
      props << property('active', NSBooleanAttributeType)
      props << property('date_moved', NSDateAttributeType)
      props << property('text', NSStringAttributeType) { |p| p.optional = true }
      props << property('photo', NSBooleanAttributeType)
      props << property('photo_uuid', NSStringAttributeType) { |p| p.optional = true }
      props << property('photo_height', NSFloatAttributeType) { |p| p.optional = true }
      props << property('photo_width', NSFloatAttributeType) { |p| p.optional = true }
      entity.properties = props

      entity
    end
  end
  
  def self.property(name, type)
    property = NSAttributeDescription.alloc.init
    property.name = name
    property.attributeType = type
    property.optional = false
    yield property if (block_given?)
    property
  end
  
  def dotted?
    dotted == 1
  end
  
  def active?
    active == 1
  end

  def photo?
    photo == 1
  end
    
end