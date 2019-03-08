require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

CarrierWave.configure do |config|
  config.root = File.dirname(__FILE__) + "/public"
end

use Rack::MethodOverride
use VinylsController
use UsersController
use DatabaseVinylController
run ApplicationController
