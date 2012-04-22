require "erb"
module Admin::ReportsHelper
  def print_report_cell(_cell)
    rhtml =<<HTML
<% _cell.each do |cell| %>
  <% cell.each do |key, val| %>
    <strong><%= key.to_s.titleize %></strong>
    <% if val.is_a? Array %>
      <p>
        <% val.each do |elem| %>
          <% elem.each do |k, v| %>
            <strong><%= k.to_s.titleize %></strong>
            <p><%= v.to_s %></p>
          <% end %>
          <hr>
        <% end %>
      </p>
    <% elsif val.is_a? Hash %>
      <p>
        <% val.each do |k, v| %>
          <strong><%= k.to_s.titleize %></strong>
          <p><%= v.to_s %></p>
        <% end %>
      </p>
    <% else %>
      <p><%= val %></p>
    <% end %>
  <% end %>
  <hr>
<% end %>
HTML
    html = ERB.new(rhtml).result(binding)
    sanitize(html)
  end

end
