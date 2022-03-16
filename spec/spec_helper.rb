require 'active_support/all'
require 's3_direct_upload'
require 'climate_control'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
