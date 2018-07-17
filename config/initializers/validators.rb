Dir[Rails.root.join('app/validators/**/*.rb')].each { |f| require f }
