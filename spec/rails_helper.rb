
ENV["RAILS_ENV"] ||= 'test'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'


Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

#reduce IO overhead
Rails.logger.level = 4

RSpec.configure do |config|
  config.order = "random"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

