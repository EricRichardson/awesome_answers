class Product < ActiveRecord::Base

  private

  def self.search(search_term, sort_by_column, current_page, per_page_count)
    where("name ILIKE ? OR description ILIKE ?", "%#{search_term}%", "%#{search_term}%").order("#{sort_by_column}").offset((current_page - 1) * per_page_count).limit(per_page_count)
  end
end
