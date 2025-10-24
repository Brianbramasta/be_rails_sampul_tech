# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins '*'
    origins 'http://localhost:3000' # Dalam produksi, ganti dengan domain frontend yang sebenarnya
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']
  end
end