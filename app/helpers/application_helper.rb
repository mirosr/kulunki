module ApplicationHelper
  def render_flash_messages
    divs = ''
    flash.each do |type, value|
      divs += content_tag(:div, value, class: type) if value.present?
    end
    divs.html_safe
  end

  def render_model_errors(model)
    render 'shared/model_errors', model: model
  end
end
