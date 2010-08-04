# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # converts a string into a dom-friendly version.
  def dom_friend(args)
    id = args[:id]
    id.downcase.gsub(' ', '_')
  end
end
