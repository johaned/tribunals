Fog.mock!
CarrierWave.configure do |config|
  config.fog_directory = 'just-testing'
end
connection = Fog::Storage.new(:provider => 'AWS')
connection.directories.create(:key => 'just-testing')

