# Files with decorator concerns
#
Dir[Rails.root.join('app/decorators/concerns/**/*.rb')].each { |f| require f }
