module ApplicationHelper
	def flash_class(level)
		case level
		when :notice then 'alert alert-success'
		when :alert then 'alert alert-danger'
		end
	end

	def profile_link_for(record)
    if record.user.present?
      link_to record.user.full_name, user_path(record.user), class: 'text-dark text-decoration-none'
    else
      content_tag(:p, 'User not available', class: 'text-muted')
    end
  end
end
