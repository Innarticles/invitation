# Invitation requires configuration.#
module Invitation
  # Configure the invitation module. Invoke from a rails initializer.
  #
  # Example:
  #   Invitation.configure do |config|
  #     config.user_registration_path = ->(params) { new_profile_path(param) }
  #   end
  #
  class Configuration
    # ActiveRecord model class name that represents your user.
    #
    # Defaults to '::User'.
    # @return [ActiveRecord::Base]
    attr_accessor :user_model

    # Url for new users to register for your application. New users are invited to
    # sign up at this url via email. The url should be expressed as a lambda that
    # accepts one argument, a params hash. This hash will contain the invitation token.
    #
    # Defaults to: ->(params) { Rails.application.routes.url_helpers.sign_up_url(params) }
    #
    # Note that the default assumes you have `sign_up_url`.
    #
    # @return [Lambda]
    attr_accessor :user_registration_url

    # Controls the 'from' address for Invitation emails.
    # Set this to a value appropriate to your application.
    #
    # Defaults to reply@example.com.
    #
    # @return [String]
    attr_accessor :mailer_sender

    # Enable or disable Invitation's built-in routes.
    #
    # Defaults to 'true'.
    #
    # If you disable the routes, your application is responsible for all routes.
    #
    # You can deploy a copy of Invitations's routes with `rails generate invitation:routes`,
    # which will also set `config.routes = false`.
    #
    # @return [Boolean]
    attr_accessor :routes


    # Url for redirects after the invites has been sent
    #
    # Defaults to: '/'
    #
    #
    # @return [String]
    attr_accessor :user_registration_url

    def initialize
      @user_model = ::User
      @user_registration_url = ->(params) { Rails.application.routes.url_helpers.sign_up_url(params) }
      @mailer_sender = 'reply@example.com'
      @routes = true
      @url_after_invite = '/'
    end

    def user_model_class_name
      @user_model.name.to_s
    end

    def user_model_instance_var
      '@' + @user_model.name.demodulize.underscore
    end

    # @return [Boolean] are Invitation's built-in routes enabled?
    def routes_enabled?
      @routes
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
