require "erb"
module Admin::ReportsHelper
  def print_report_cell(_cell)
    rhtml =<<HTML
<% _cell.each do |cell| %>
  <%= label_tag cell[:label] %>
  <div><%= cell[:label] == "Price" ? number_to_currency(cell[:value]) : cell[:value].to_i %></div>
<% end %>
HTML
    html = ERB.new(rhtml).result(binding)
    sanitize(html)
  end

end
