module ApplicationHelper
  def age_for(date)
    Date.today.year - date.year
  end
end
