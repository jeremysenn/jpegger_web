module SearchesHelper
  
  def searches_sort_link(column, title = nil)
    title ||= column.titleize
    direction = (column == searches_sort_column && searches_sort_direction == "asc") ? "desc" : "asc"
    icon = (searches_sort_direction == "asc" ? "fa fa-chevron-up" : "fa fa-chevron-down")
    icon = (column == searches_sort_column ? icon : "")
    link_to "#{title} <i class='#{icon}'></i>".html_safe, {searches_column: column, searches_direction: direction}
  end
  
end
