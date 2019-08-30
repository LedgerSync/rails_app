Config.setup do |config|
  # Name of the constant exposing loaded settings
  config.const_name = 'Settings'

  config.fail_on_missing = true

  # Ability to remove elements of the array set in earlier loaded settings file. For example value: '--'.
  #
  # config.knockout_prefix = nil

  # Overwrite an existing value when merging a `nil` value.
  # When set to `false`, the existing value is retained after merge.
  #
  # config.merge_nil_values = true

  # Overwrite arrays found in previously loaded settings file. When set to `false`, arrays will be merged.
  #
  # config.overwrite_arrays = true

  # Load environment variables from the `ENV` object and override any settings defined in files.
  #
  config.use_env = true

  # Define ENV variable prefix deciding which variables to load into config.
  #
  config.env_prefix = 'SETTINGS'

  # What string to use as level separator for settings loaded from ENV variables. Default value of '.' works well
  # with Heroku, but you might want to change it for example for '__' to easy override settings from command line, where
  # using dots in variable names might not be allowed (eg. Bash).
  #
  config.env_separator = '__'

  # Ability to process variables names:
  #   * nil  - no change
  #   * :downcase - convert to lower case
  #
  config.env_converter = :downcase

  # Parse numeric values as integers instead of strings.
  #
  config.env_parse_values = true

  # Validate presence and type of specific config values. Check https://github.com/dry-rb/dry-validation for details.
  #
  contract = Class.new(Dry::Validation::Contract)
  contract.params do
    required(:adaptors).maybe do
      schema do
        required(:quickbooks_online).maybe do
          schema do
            required(:oauth_client_id).filled(:str?)
            required(:oauth_client_secret).filled(:str?)
            required(:oauth_redirect_uri).filled(:str?)
          end
        end
      end
    end

    required(:add_ons).maybe do
      schema do
        required(:paper_trail).maybe do
          schema do
            required(:enabled).filled(:bool?)
          end
        end

        optional(:sentry).filled do
          schema do
            optional(:enabled).maybe(:bool?)
            optional(:dsn).maybe(:str?)
          end
        end
      end
    end

    required(:api).schema do
      required(:root_secret_key).filled(:str?)
    end

    required(:application).schema do
      required(:host_port).maybe(:int?)
      required(:host_url).filled(:str?)
      required(:login_url).maybe(:str?)
      required(:name).filled(:str?)
      optional(:theme).maybe(:str?)
      optional(:webhooks).schema do
        optional(:url).maybe(:str?)
        optional(:key).maybe(:str?)
      end
    end

    optional(:customization).schema do
      optional(:after_application_css_urls).maybe do
        each(:str?)
      end
      optional(:before_application_css_urls).maybe do
        each(:str?)
      end
    end

    required(:mailer).filled do
      schema do
        required(:delivery_method).filled(:str?)
        optional(:smtp).filled do
          schema do
            required(:address).filled(:str?)
            required(:authentication).filled(:str?)
            required(:enable_starttls_auto).filled(:bool?)
            required(:password).filled(:str?)
            required(:port).filled(:int?)
            required(:username).filled(:str?)
          end
        end
      end
    end
  end

  contract.rule(add_ons: [:sentry, :dsn]) do
    key.failure('must be filled') if values.dig(:add_ons, :sentry, :enabled) == true && values.dig(:add_ons, :sentry, :dsn).blank?
  end

  contract.rule(application: [:webhooks, :key]) do
    key.failure('must be filled') if values.dig(:application, :webhooks, :url).present? && values.dig(:application, :webhooks, :key).blank?
  end

  contract.rule(mailer: [:smtp]) do
    key.failure('must be filled') if values.dig(:mailer, :delivery_method) == 'smtp' && values.dig(:mailer, :smtp).blank?
  end

  config.validation_contract = contract.new
end
