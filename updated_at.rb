
    <% if survey.updated_at.year == survey.created_at.year %>
    <% if survey.updated_at.month == survey.created_at.month %>
    <% if survey.updated_at.day == survey.created_at.day %>
    <% if survey.updated_at.hour == survey.created_at.hour %>
    <% if survey.updated_at.min == survey.created_at.min %>
    <%= "0 minutes ago" %>
    <% else %>
    <%= (survey.updated_at.min - survey.created_at.min).to_s+" minutes ago" %>
    <% end %>
    <% else %>
    <%= (survey.updated_at.hour - survey.created_at.hour).to_s+" hours ago" %>
    <% end %>
<% else %>
<%= (survey.updated_at.day - survey.created_at.day).to_s+ " days ago" %>
<% end %>
<% else %>
<%= (survey.updated_at.month - survey.created_at.month).to_s+" months ago" %>
<% end %>
<% else %>
<%= (survey.updated_at.year - survey.created_at.year).to_s+" years ago" %>
<% end %>
