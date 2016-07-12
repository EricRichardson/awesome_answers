CarrierWave.configure do |config|
                          # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV["S3_ACCESS_KEY"],         # required
    aws_secret_access_key: ENV["S3_SECRET"],             # required
    region:                'us-west-2',                  # optional, defaults to 'us-east-1'
    
  }
  config.fog_directory  = 'erics-awesome-answers'                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end
