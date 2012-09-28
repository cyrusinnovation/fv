class CoreDataTask < NSManagedObject
  attribute :is_dotted #boolean
  attribute :is_active #boolean
  attribute :date_moved #date
  attribute :text #string
  attribute :is_photo #boolean
  attribute :photo_uuid #string
  attribute :photo_height #float
  attribute :photo_width #float

  def dotted?
    is_dotted
  end
  
  def dotted= dotted
    self.is_dotted = dotted
  end
  
  def active?
    is_active
  end
  
  def active= active
    self.is_active = active
  end

  def photo?
    is_photo
  end
  
  def photo= photo
    self.is_photo = photo
  end
  
  def objectID
    self.key
  end
end