class ToggleButtonView < UIView
  
  def initWithFirstView(first_view, secondView:second_view)
    
    if initWithFrame(first_view.frame)
      @current_view = first_view
      @other_view = second_view
      addSubview(first_view)
    end
    self
    
  end
  
  def toggle
    @current_view.removeFromSuperview
    addSubview(@other_view)
    @current_view, @other_view = @other_view, @current_view
  end
  
end