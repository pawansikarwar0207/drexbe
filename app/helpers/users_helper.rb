module UsersHelper
	def verification_icons(user)
    return '' if user.nil?

    icons = []

    # Phone Icon
    if user.phone_number.present?
      icons << content_tag(:i, '', class: 'fas fa-mobile-alt text-dark', 
                           data: { bs_toggle: 'tooltip', bs_placement: 'top' }, 
                           title: 'Phone number is verified')
    else
      icons << content_tag(:i, '', class: 'fas fa-mobile-alt text-danger', 
                           data: { bs_toggle: 'tooltip', bs_placement: 'top' }, 
                           title: 'Phone number not verified')
    end

    # ID Card Icon
    if user.identity_card_document.attached?
      icons << content_tag(:i, '', class: 'fa fa-address-card text-dark', 
                           data: { bs_toggle: 'tooltip', bs_placement: 'top' }, 
                           title: 'ID card is verified')
    else
      icons << content_tag(:i, '', class: 'fa fa-address-card text-danger', 
                           data: { bs_toggle: 'tooltip', bs_placement: 'top' }, 
                           title: 'ID card not verified')
    end

    # Email Icon
    if user.confirmed?
      icons << content_tag(:i, '', class: 'fa fa-envelope text-dark', 
                           data: { bs_toggle: 'tooltip', bs_placement: 'top' }, 
                           title: 'Email is verified')
    else
      icons << content_tag(:i, '', class: 'fa fa-envelope text-danger', 
                           data: { bs_toggle: 'tooltip', bs_placement: 'top' }, 
                           title: 'Email not verified')
    end

    # Join the icons with a space and return as HTML safe
    icons.join(' ').html_safe
  end
end
