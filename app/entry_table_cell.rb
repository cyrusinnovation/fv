class EntryTableCell < UITableViewCell
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      textField = UITextField.alloc.initWithFrame(self.contentView.frame)
      textField.delegate = self
      self.contentView.addSubview(textField)
    end
    self
  end
  
  # Defined for UITextFieldDelegate
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    textField.text = nil
    true
  end

  def textFieldDidEndEditing(textField)
    NSNotificationCenter.defaultCenter.postNotificationName("textFieldDoneEditing", object:textField.text)
    true
  end
  
end

