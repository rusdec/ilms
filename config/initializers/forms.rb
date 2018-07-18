# Files with Form Objects
#
Dir[Rails.root.join('app/forms/**/*.rb')].each { |f| require f }
