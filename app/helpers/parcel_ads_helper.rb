module ParcelAdsHelper
	def friendly_status_label(status)
    {
      "pending" => "Pending",
      "confirmed" => "Confirmed",
      "in_transit" => "In Transit",
      "out_for_delivery" => "Out for Delivery",
      "delivered" => "Delivered",
      "cancelled" => "Cancelled"
    }[status.to_s] || "Unknown"
  end

  def bootstrap_status_class(status)
    {
      "pending" => "secondary",
      "confirmed" => "info",
      "in_transit" => "primary",
      "out_for_delivery" => "warning",
      "delivered" => "success",
      "cancelled" => "danger"
    }[status.to_s] || "dark"
  end

  def status_badge_class(status)
    case status.to_s
    when 'pending'
      'bg-yellow-500'
    when 'in_transit'
      'bg-blue-500'
    when 'delivered'
      'bg-green-600'
    when 'returned'
      'bg-red-500'
    else
      'bg-gray-400'
    end
  end
end
