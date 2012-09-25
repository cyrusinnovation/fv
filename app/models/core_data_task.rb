class CoreDataTask < NSManagedObject
  DB_FALSE = 0
  DB_TRUE = 1

  def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = 'Task'
      entity.managedObjectClassName = 'CoreDataTask'
      
      props = []
      props << property('is_dotted', NSBooleanAttributeType)
      props << property('is_active', NSBooleanAttributeType)
      props << property('date_moved', NSDateAttributeType)
      props << property('text', NSStringAttributeType) { |p| p.optional = true }
      props << property('is_photo', NSBooleanAttributeType)
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
    is_dotted == DB_TRUE
  end
  
  def dotted= dotted
    self.is_dotted = dotted ? DB_TRUE : DB_FALSE
  end
  
  def active?
    is_active == DB_TRUE
  end
  
  def active= active
    self.is_active = active ? DB_TRUE : DB_FALSE
  end

  def photo?
    is_photo == DB_TRUE
  end
  
  def photo= photo
    self.is_photo = photo ? DB_TRUE : DB_FALSE
  end
    
end