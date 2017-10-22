module ApplicationHelper
  def precip_info(type, probability)
    return 'Sunny' if type.blank?

    out = "#{type.capitalize} "
    out << "#{probability * 100}% " if probability.present?
    out.html_safe
  end

  def precip_icon(type)
    type.downcase!
    icon_class = 'fa-sun-o'

    if type.include? 'cloud'
      icon_class = 'fa-cloud'
    elsif type.include? 'rain'
      icon_class = 'fa-tint'
    elsif type.include? 'snow'
      icon_class = 'fa-snowflake-o'
    end

    "<i class='fa #{icon_class} aria-hidden='true'></i>".html_safe
  end
end
