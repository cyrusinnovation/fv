class EntryTableCell < UITableViewCell
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      taskViewFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)
      textField = UITextField.alloc.initWithFrame(taskViewFrame)
      textField.delegate = self
      textField.backgroundColor = UIColor.greenColor
      textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      self.contentView.addSubview(textField)
    end
    self
  end
  
  # Defined for UITextFieldDelegate
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    return true
  end
  
  
end

