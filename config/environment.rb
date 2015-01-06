# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
AWS::S3::DEFAULT_HOST = "s3-eu-west-1.amazonaws.com" #if using eu buckets.
Moovup::Application.initialize!
