# Loads the application configuration at /config/app_config.yml
# This option is chosen in favor of ENV since it does not override any ENV variable.

app_config = nil

config_file = "app_config.yml"

begin
  raw_config = File.read("#{Rails.root}/config/#{config_file}")
  app_config = YAML.load(raw_config)[Rails.env].symbolize_keys

  if %w(staging).include?(Rails.env)
    app_config[:last_commit_message] = `git log -1 --oneline`
    date_time = Rails.root.to_s.split('/').last
    app_config[:deploy_timestamp] = DateTime.parse(date_time)
  end
rescue StandardError => e
  puts "WARNING - Could not find #{config_file} !! -- Check other alternatives"
  app_config = {}
end

# Holds configuration in a class to encapsulate extracting it from various sources
class AppConfig

  attr_accessor :config

  # Initialize on the passed config [Hash]
  def initialize(config)
    @config = config
  end

  # get the value from given config OR ENV variables set directly on server
  def [](key)
    @config[key] || ENV[key.to_s] || ENV[key.to_s.upcase]
  end

  # get whole hash
  def file_config
    @config
  end

  # file + env
  def complete_config
    @config.merge ENV
  end
end

# Set the constant APP_CONFIG to the AppConfig instance
APP_CONFIG = AppConfig.new(app_config)
