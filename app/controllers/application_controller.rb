class ApplicationController < ActionController::Base
  def enable_varnish
    headers['X-Varnish-Enable'] = '1'
  end

  def set_cache_control(timestamp)
    fresh_when(last_modified: timestamp, public: true)
  end
end
