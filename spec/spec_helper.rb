# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

# Require the spec integration
require 'rspec/rails'
#require 'rspec/autorun'

require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| load f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  Capybara.default_host = "http://127.0.0.1"
  Capybara.javascript_driver = :webkit

  # This allows you to tag an exaple with :focus to make it run with Guard
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true


  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Warden::Test::ControllerHelpers, type: :controller

  def sign_in
    warden.set_user(true)
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

def sample_pdf_file
  File.open('spec/fixtures/te3-eng.pdf')
end

def sample_doc_file
  File.open('spec/fixtures/te3-eng.doc')
end

def sample_doc_file2
  File.open('spec/fixtures/IA195402012___20_IA195412012_00AA099162012.doc')
end

def decision_hash(h={})
  {
    ncn: [2013, 'UKIT', rand(31337)].join(' '),
    doc_file: sample_doc_file,
    promulgated_on: Date.today,
    claimant: 'John Smith',
    reported: true,
    country: 'Gibraltar',
    country_guideline: false,
    judges: ['Judge Dredd']
  }.merge(h)
end

def aac_decision_hash(h={})
  {
    ncn: '2013 UKUT 500 AAC',
    doc_file: sample_doc_file,
    decision_date: Date.today,
    claimant: 'John Smith',
    respondent: 'Partnerships in Care and Secrerary of State for Justice',
    is_published: true,
    aac_decision_subcategory_id: 172
  }.merge(h)
end

def ftt_decision_hash(h={})
  {
    file_number: 'v18158',
    doc_file: sample_doc_file,
    decision_date: Date.today,
    claimant: 'Will Smith',
    respondent: 'Men in Black',
    is_published: true
  }.merge(h)
end
