PASSWORD_FILE = Rails.env.production? ? File.join(Rails.root, '../shared/password.hash') : File.join(Rails.root, 'db/password.hash')

Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Admin::AuthenticationsController.action(:new)
end

class Warden::SessionSerializer
  def serialize(_)
    ''
  end

  def deserialize(_)
    true
  end
end

Warden::Strategies.add(:password) do
  def valid?
    params[:password]
  end

  def authenticate!
    return BCrypt::Password.new(File.read(PASSWORD_FILE)) == params[:password] ? success!(true) : fail!
  end
end
