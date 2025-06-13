class Rack::Attack
  # Throttle requests to 3 per second per IP for geocode
  throttle('geocode/ip', limit: 3, period: 1) do |req|
    req.path.start_with?('/geocode') ? req.ip : nil
  end
end
