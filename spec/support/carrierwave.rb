

module MockCarrierwave
  extend self

  def apply
    Fog.mock!
    Fog.credentials = credentials

    CarrierWave::Configuration.configure_fog! directory: bucket, credentials: credentials

    connection = Fog::Storage.new provider: credentials[:provider]
    connection.directories.create key: bucket
  end

  def bucket
    'test-bucket'
  end

  def credentials
    {
      provider: 'AWS',
      aws_access_key_id: 'someaccesskeyid',
      aws_secret_access_key: 'someprivateaccesskey',
      region: 'us-east-1'
    }
  end
end

MockCarrierwave.apply
