# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # converts a string into a dom-friendly version.
  def dom_friend(args)
    id = args[:id]
    id.downcase.gsub(' ', '_')
  end
  
  
  ##
  # allows a block of link_to()'s to be given the active class if they are the current page.
  #
  def is_active?(page_name)
    "active" if params[:action] == page_name
  end
  
  def my_paper?
    "active" if params[:action] == "show" && owner_or_admin?
  end
  
  def shared_paper?
    "active" if params[:action] == "show" && !owner_or_admin?
  end
end
