# frozen_string_literal: true

# spec/support/api_helper.rb
module APIHelpers
  include Rack::Test::Methods

  def api_build_path(action, version: 'v1')
    "/api/#{version}#{'/' unless action[0] == '/'}#{action}"
  end

  def api_get(*args)
    api_request(:get, *args)
  end

  def api_post(*args)
    api_request(:post, *args)
  end

  def api_delete(*args)
    api_request(:delete, *args)
  end

  def api_put(*args)
    api_request(:put, *args)
  end

  def api_request(method, action, params: {}, headers: {}, version: 'v1')
    use_headers = @env || {}

    headers&.each do |k, v|
      use_headers[k] = v
    end

    action = path_for(action) unless action.is_a?(String)
    url = api_build_path(action, version: version)
    pdb "#{url} : #{params.inspect}" if @verbose
    response = send(method, url, params, use_headers)
    prb if @verbose || verbose_status?(response.status)
  end

  def app
    Rails.application
  end

  def header_key(key)
    key = key.to_s.upcase
    raise "Key cannot include hyphens: #{key}" if key.include?('-')

    return key if key[0..4] == 'HTTP_'

    'HTTP_' + key
  end

  def set_header(key, val)
    @env ||= {}
    @env[header_key(key)] = val
  end

  def api_list_first
    json['data'].first
  end

  def api_list_structure?(response_data)
    json['data'].is_a?(Array)
  end

  def expect_200
    prb if last_response.status != 200
    expect_status(200)
  end

  def expect_400
    expect_status(400)
  end

  def expect_401
    expect_status(401)
  end

  def expect_404
    expect_status(404)
  end

  def expect_498
    expect_status(498)
  end

  def expect_api_list_structure(length = nil, object: nil)
    expect_200
    expect(api_list_structure?(json)).to eq(true)
    expect(json['data'].length).to eq(length) unless length.nil?
    expect(json['data'].first['object']).to eq(object.to_s) if object.present?
  end

  def expect_error(type, message = nil, status = 400, sub_type: nil)
    expect_status(status)
    expect(json).to include('error')
    expect(json['error']).to include('type' => type)
    expect(json['error']['message']).to include(message) if message.present?
    expect(json['error']['sub_type']).to include(sub_type) if sub_type.present?
  end

  def expect_error_with_param(param, message = nil)
    expect_invalid_request_error
    expect(json['error']).to include('param' => param.to_s)
    expect(json['error']['message']).to include(message) if message.present?
  end

  def expect_idempotency_error(idempotency_error_type:)
    expect_invalid_request_error(sub_type: 'idempotency_error')
    expect(json['error']['idempotency_error_type'].try(:to_sym)).to eq(idempotency_error_type.to_sym)
  end

  def expect_invalid_request_error(message = nil, **keywords)
    expect_error('invalid_request_error', message, **keywords)
  end

  def expect_missing_required_param_error(param)
    expect_error_with_param(param)
  end

  def expect_no_such_record_error(param = 'id', message = nil)
    expect_error('no_such_record', message, 404)
    expect(json['error']['param']).to eq(param.to_s)
  end

  def expect_object_of_type(type)
    expect_200
    expect(json['data']).to include('type' => type.to_s)
  end

  def expect_status(status)
    expect(last_response.status).to eq(status)
  end

  def json
    return nil if response_body == 'null'

    ret = JSON.parse(response_body)
    return ret.with_indifferent_access if ret.is_a?(Hash)

    ret
  end

  def post_invalid_param(*args)
    validate_param(:post, :invalid, *args)
  end

  def post_invalid_param_value(url, param, val)
    validate_param(:post, :invalid, url, nil, param, param => val)
  end

  def post_missing_required_param(*args)
    validate_param(:post, :missing, *args)
  end

  def post_valid_param(*args)
    validate_param(:post, :valid, *args)
  end

  def post_valid_param_value(url, param, val, type, expected_val = nil)
    expected_val = val if expected_val.nil?
    if block_given?
      validate_param(:post, :valid, url, type, param, param => val, param => expected_val, &Proc.new)
    else
      validate_param(:post, :valid, url, type, param, param => val, param => expected_val)
    end
  end

  def prb
    pdb json
  rescue JSON::ParseError
    pdb response_body
  end

  def put_invalid_param(*args)
    validate_param(:put, :invalid, *args)
  end

  def put_invalid_param_value(url, param, val)
    api_put url, param => val
    expect_error_with_param(param)
  end

  def put_valid_param(*args)
    if block_given?
      validate_param(:put, :valid, *args, &Proc.new)
    else
      validate_param(:put, :valid, *args)
    end
  end

  def put_valid_param_value(url, param, val, type)
    params = { param => val }
    api_put url, params
    expect_object_of_type(type)
    expect(json).to include(params)
  end

  def put_json(prefix = 'DEBUG-JSON: ')
    puts "#{prefix} #{json}"
  end

  def response_body
    response.body
  rescue StandardError
    last_response.body
  end

  def search_api_get(*args, **keywords)
    api_request(:get, *args, **{ version: 'search/v1' }.merge(keywords))
  end

  def stringify_keys(h)
    # Hash[hash.map{ |k, v| [k.to_s, v] }]
    if h.is_a? Hash
      Hash[
        h.map do |k, v|
          [k.respond_to?(:to_s) ? k.to_s : k, stringify_keys(v)]
        end
      ]
    else
      h
    end
  end

  def unset_header(key)
    @env ||= {}
    @env.delete(header_key(key))
  end

  def validate_param(method, type, url, obj, param, attributes, test_attributes = nil)
    param = param.to_s unless param.is_a? String

    case type
    when :missing
      attributes.delete param
    end

    case method
    when :post
      api_post url, stringify_keys(attributes)
    when :put
      api_put url, stringify_keys(attributes)
    end

    prb if @verbose

    case type
    when :missing
      expect_error_with_param(param)
    when :valid
      obj = obj.to_s unless obj.is_a? String
      expect_object_of_type(obj)
      if block_given?
        yield(json)
      else
        expect(json).to include(stringify_keys(test_attributes || attributes))
      end
    when :invalid
      expect_error_with_param(param)
    end
  end

  def verbose_status?(status)
    status > 500 || status == 402
  end

  def with_authorization(headers: {})
    token = 'asdfasdf'

    # set_header('HTTP_AUTHORIZATION', ActionController::HttpAuthentication::Basic.encode_credentials(token, ''))
    header 'Authorization', "Bearer #{token}"
    headers.each { |k, v| set_header(k, v) }

    ClimateControl.modify(SETTINGS__API__ROOT_SECRET_KEY: token) do
      Settings.reload!
      yield
    end

    Settings.reload!

    # unset_header('HTTP_AUTHORIZATION')
    header 'Authorization', ''
    headers.each { |k, _v| unset_header(k) }
  end

  def with_idempotency(key: nil)
    @request_count ||= 0
    @request_count += 1

    key ||= "ikey_#{@request_count}"

    set_header('HTTP_IDEMPOTENCY_KEY', key)
    header 'IDEMPOTENCY_KEY', key

    yield

    unset_header('HTTP_IDEMPOTENCY_KEY')
    header 'IDEMPOTENCY_KEY', ''
  end
end
