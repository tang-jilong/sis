# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def activities_from(activities, client, project=nil, role=nil)
    activities = activities.select { |a| a.project.client == client }
    if project
      activities = activities.select { |a| a.project == project }
      activities = activities.select { |a| a.user.role == role  } if role
    end
    activities.sort_by { |a| a.date }
  end
  
  def total_from(activities)
    format_minutes(activities.inject(0) { |a,act| a + act.minutes })
  end
  
  def activities_table(activities, options={})
    default_options = { :show_checkboxes => false, :show_users => true,
                          :show_details_link => true, :show_edit_link => true,
                          :show_delete_link => true, :show_exclude_from_invoice_link => false,
                          :expanded => false, :show_date => true }
    
    options = default_options.merge(options)
    
    table_opts = { :class => 'activities list wide', :id => "#{options[:table_id]}"}
    table_opts.reject!{|k,v| v.blank?}
    
    tag(:table, table_opts) do
      html =  %(<tr>)
      html << %(<th class="checkbox">#{check_box :class => "activity_select_all"}</th>) if options[:show_checkboxes]
      html << %(<th>#{image_tag("icons/project.png", :alt => 'project') if options[:show_header_icons]} Project</th>) if options[:show_project]
      html << %(<th>#{image_tag("icons/role.png", :alt => 'role') if options[:show_header_icons]} User</th>) if options[:show_users]
      html << %(<th>Date</th>) if options[:show_date]
      html << %(<th class="right">#{image_tag("icons/clock.png", :alt => 'clock') if options[:show_header_icons]} Hours</th>)
      html << %(<th class="icons">)
      html << link_to(image_tag("icons/magnifier.png", :title => "Toggle all details", :alt => 'I'), "#", :class => "toggle_all_comments_link") if options[:show_details_link]
      html << %(</th>)
      html << %(</tr>)
      activities.each do |activity|
        html << activities_table_row(activity, options)
      end
      html << %(<tr class="no_zebra">)
      html << %(<td></td>) if options[:show_checkboxes]
      html << %(<td></td>) if options[:show_project]
      html << %(<td></td>) if options[:show_users]
      html << %(<td class="right"><strong>Total:</strong></td>)
      html << %(<td class="right"><strong>#{total_from(activities)}</strong></td></tr>)
    end
  end
  
  
end
