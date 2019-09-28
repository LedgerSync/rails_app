# Ledger Sync App
by [Modern Treasury](https://www.moderntreasury.com)

[![Build Status](https://travis-ci.org/LedgerSync/rails_app.svg?branch=master)](https://travis-ci.org/LedgerSync/rails_app)
[![Coverage Status](https://coveralls.io/repos/github/LedgerSync/rails_app/badge.svg?branch=master)](https://coveralls.io/github/LedgerSync/rails_app?branch=master)

Ledger Sync App is an open source application that allows you to easily sync to any supported accounting software.  This repository is a Ruby on Rails application you can spin up and run on your own servers.  Think of it as the "front end," while the [Ledger Sync App Lib](https://www.github.com/Modern-Treasury/organization-connector-lib) is the underlying worker.

The library handles translating structured data and syncing it to supported accounting software.  Our goal is to keep this application as generic and lean as possible, not requiring changes with every modification to the library.  The main goals of this app are the following:

1. Provide a quick and easy integration to accounting software.
2. Enable the user to connect accounting software.
3. Pass through any sync requests to the library and record ledger_resources of external objects to objects in the accounting software.

As a "provider" of this application to your users, you have the following capabilities:

1. Create and manage organizations.
2. Create, manage, and associate users to organizations.
3. Authenticate users to the application.
4. Sync data

# Supported Ledgers

This application is designed to require minimal modifications with updates to the library.  When a new ledger is added, this application will need to be updated to support connecting to the new ledger.  Please see the [Ledger Sync App Lib](https://www.github.com/Modern-Treasury/organization-connector-lib) for the ledger-specific support, as one ledger may support syncing an object (e.g. Invoice) while another may not.

## QuickBooks Online

- Supports QuickBooks Online Oauth2

## Xero (coming soon)

# Setup

## Settings && Configuration

**Note: All currently available settings are described in `config/settings.yml`.**

This application uses [Config](https://github.com/railsconfig/config), a gem that manages environment-specific settings.  It works by setting values in the appropriate YAML.  The following files correspond to the following environments:

| file | environment |
| --- | --- |
| `config/settings.yml` | Default settings |
| `config/settings.local.yml` | local `development` (ignored by git) |
| `config/settings/development.yml` | development |
| `config/settings/test.yml` | test |
| `config/settings/production.yml` | production |

You can also override settings using environment variables.  For example, `Settings.api.root_secret_key` would be overwritten with `ENV['SETTINGS__API__ROOT_SECRET_KEY']`, where YAML levels are separated with `__` (two underscores).

**It is recommended to use environment variables for any sensitive information.** Though locally you can use `config/settings.local.yml`, we have also included the [dotenv](https://github.com/bkeepers/dotenv) gem to help you better simulate a production environment.

Below are settings that require a bit of setup or explanation:

### Settings.application.mailer_method

#### `Settings.application.mailer_method = :letter_opener`

Used by default in development, the application will use the [letter_opener](https://github.com/ryanb/letter_opener) gem for delivering mail.

# API

## Idempotency

All `POST` requests made to the API require an idempotency key.  To do so, provide a `Idempotency-Key: <key>` header to the request.

The application will save the resulting status code and body of the first request made for any given key, regardless of if it succeeded or failed (including `500` errors).  Keys expire after 24 hours, so if a new request with the same key is used in that time frame, the same results will be returned.

An error will be raised if the same key is used but the request body does not match the previous request.

## External IDs

Most objects in the API require and `external_id` attribute.  You can then use these interchangeably with the application's auto-generated random IDs.  The only constraint for `external_id` is that it cannot start with the same prefix as the application `id`.  For example, all user `id`s start with `usr_`.  Your `external_id` may not start with `usr_` to protect from any unintentional collisions.

This feature affords you the ability to not require storing IDs in your database for objects like organizations and users.

Please note that while you may use `external_id` or `id` interchangeably (unless otherwise specified), the API will always return the `id` attribute (e.g. the `url` attribute of `auth_token` objects will use `id`).

## Routes

All of the following routes are relative to the `Settings.application.host_url` supplied in the settings.

## Organizations

### Create an organization

```ruby
# Request
post "/api/v1/organizations", external_id: 'my-organization-id-1', name: 'Acme Co.'

# Response
{
  object: 'organization',
  id: 'org_1234567890',
  external_id: 'my-organization-id-1',
  name: 'Acme Co.'
}
```

### Retrieve an organization

```ruby
# Request
get "/api/v1/organizations/my-organization-id-1"

# Response
{
  object: 'organization',
  id: 'org_1234567890',
  external_id: 'my-organization-id-1',
  name: 'Acme Co.'
}
```

### Update an organization

```ruby
# Request
post "/api/v1/organizations/my-organization-id-1", name: 'A Different Co'

# Response
{
  object: 'organization',
  id: 'org_1234567890',
  external_id: 'my-organization-id-1',
  name: 'A Different Co'
}
```

### Add user to organization

```ruby
# Request
post "/api/v1/organizations/my-organization-id-1/users/usr_123"

# Response
{
  object: 'organization_user',
  organization: 'org_1234567890',
  user: 'usr_123'
}
```

### Remove user to organization

```ruby
# Request
delete "/api/v1/organizations/my-organization-id-1/users/usr_123"

# Response
{
  object: 'organization_user',
  organization: 'org_1234567890',
  user: 'usr_123'
}
```

## Users

### Create a user

Creates a user associated with the given organization.

```ruby
# Request
post "/api/v1/users", external_id: 'asdf', organization: '456'

# Response
{
  object: 'user',
  id: 'usr_1234567890',
  organization: 'org_qwerty',
  ...
}
```

## Authentication

The application uses Auth Tokens generated via the API to authenticate users to the application.  Auth Tokens for a given user automatically expire under the following conditions:

* A new auth token is created.
*

### Create an auth token

```ruby
# Request
post "/api/v1/users/:id/auth_tokens"

# Response
{
  object: 'auth_token',
  id: 'at_asdfasdf',
  url: '{ROOT_URL}/auth/1234567890',
  ...
}
```

### Authenticate a user

Redirect a user to the `url` of the created `auth_token`.

## Syncs

## Create a sync

```ruby
# Request
post "/api/v1/syncs", {
  organization: 'your_or_our_id',
  resource_external_id: 'your_cus_id',
  resource_type: 'customer',
  operation_method: 'upsert',
  references: {
    customer: {
      'your_cus_id': {
        data: {
          name: 'Sample Customer',
          email: 'sample@example.com'
        }
      }
    }
  }
}

# Response
{
  object: 'sync',
  id: 'sync_abc123',
  status: 'created'
}
```

# Features

## API Subdomain

If you want to separate the UI and API, the application can be run on the subdomain `https://api.ROOT_URL`.  This allows you to optimize for high API usage.

# Add-Ons

## PaperTrail

https://github.com/paper-trail-gem/paper_trail

To enable, set `Settings.paper_trail.enabled = true`

# Development

## QuickBooks Online

### Setup

Register at https://developer.intuit.com and create new App as below. In `Redirect URIs` enter `http://localhost:3000/qbo/callback` If it says that it's invalid, ignore it and hit save. There is no confirmation, but after refresh it will be persisted.

You will need to set the following ENV vars in your `.env` or local settings YAML:

`SETTINGS__ADAPTORS__QUICKBOOKS_ONLINE__OAUTH_CLIENT_ID`: `Client ID` from App > Keys
`SETTINGS__ADAPTORS__QUICKBOOKS_ONLINE__OAUTH_CLIENT_SECRET`: `Client Secret` from App > Keys
`SETTINGS__ADAPTORS__QUICKBOOKS_ONLINE__OAUTH_REDIRECT_URI`: `http://localhost:3000/ledgers/quickbooks_online/callback`

- Access token is issued only for 1h.
- Refresh token is issued for 100 days.
- Once Access token expires, you will need to click `Refresh` button that will get you new access token.
- Each day they generate new refresh token when you try to refresh.

More details about tokens can be found [here](https://help.developer.intuit.com/s/question/0D50f000051WZUGCA4/refresh-token-is-expiring-each-day-instead-of-lasting-100-days)

![2019-04-04 12 26 00](https://user-images.githubusercontent.com/482174/55549323-db5f7600-56d5-11e9-9169-985c5910aa40.gif)

## Local Gem Configuration

If you are developing on both this project and the `ledger-sync-app-lib`, you may want to set your local Gemfile to use your local gem:

1. `$ bundle config local.ledger_sync /path/to/ledger_sync/ledger_sync_app`
2. Add `gem 'ledger_sync', github: 'ledger_sync/ledger_sync', branch: 'master'` inside your `development` and/or `test` block.


To remove:

`$ bundle config --delete local.ledger_sync`

## Caching

The app leverages fragment caching using a Russian Doll strategy.  To enable/disable caching in development, run `bundle exec rails dev:cache`.

# API

## Resources

### Create a resource

**Route**

`POST /api/v1/resources`

**Params**

| attribute | constraints | type | description |
| --- | --- | --- | --- |
| external_id | required | string | The new external_id of the resource |
| organization | required | string | The `id` or `external_id` of the organization |
| type | required | string | A valid type supported by LedgerSync |

**Example**

```ruby
# Request
post "/api/v1/resources", external_id: 'my-resource-id-1', organization: 'org_abc', type: 'customer'

# Response
{
  object: 'resource',
  id: 'rsrc_1234567890',
  external_id: 'my-resource-id-1',
  organization: 'org_abc',
  type: 'customer
}
```

### Retrieve a resource

**Route**

`GET /api/v1/resources/:id`

**Example**

```ruby
# Request
get "/api/v1/resources/my-resource-id-1"

# Response
{
  object: 'resource',
  id: 'rsrc_1234567890',
  external_id: 'my-resource-id-1',
  organization: 'org_abc',
  type: 'customer
}
```

### Update a resource

**Route**

`POST /api/v1/resources/:id`

**Params**

| attribute | constraints | type | description |
| --- | --- | --- | --- |
| external_id | required | string | The new external_id of the resource |

**Example**

```ruby
# Request
post "/api/v1/resources/my-resource-id-1", external_id: 'a_new_external_id'

# Response
{
  object: 'resource',
  id: 'rsrc_1234567890',
  external_id: 'a_new_external_id',
  organization: 'org_abc',
  type: 'customer
}
```

### Create a ledger_resource

**Route**

`POST /api/v1/ledger_resources`

**Params**

| attribute | constraints | type | description |
| --- | --- | --- | --- |
| ledger | required | string | The `id` of the ledger |
| resource | required | string | The `id` or `external_id` of the resource |
| resource_ledger_id | required | string | The `id` of the resource in the ledger.  This is to be retrieved from the ledger itself. |

**Example**

```ruby
# Request
post "/api/v1/ledger_resources", ledger: 'ldgr_123', resource: 'rsrc_987', resource_ledger_id: 'qbo_customer_1_id'

# Response
{
  object: 'ledger_resource',
  id: 'rsrc_1234567890',
  ledger: 'ldgr_123',
  resource: 'rsrc_987',
  resource_ledger_id: 'qbo_customer_1_id'
}
```

### Retrieve a ledger_resource

**Route**

`GET /api/v1/ledger_resources/:id`

**Example**

```ruby
# Request
get "/api/v1/ledger_resources/my-ledger_resource-id-1"

# Response
{
  object: 'ledger_resource',
  id: 'rsrc_1234567890',
  ledger: 'ldgr_123',
  resource: 'rsrc_987',
  resource_ledger_id: 'qbo_customer_1_id'
}
```

### Update a ledger_resource

**Route**

`POST /api/v1/ledger_resources/:id`

**Params**

| attribute | constraints | type | description |
| --- | --- | --- | --- |
| resource_ledger_id | required | string | The `id` of the resource in the ledger.  This is to be retrieved from the ledger itself. |

**Example**

```ruby
# Request
post "/api/v1/ledger_resources/my-ledger_resource-id-1", resource_ledger_id: 'new_qbo_customer_1_id'

# Response
{
  object: 'ledger_resource',
  id: 'rsrc_1234567890',
  ledger: 'ldgr_123',
  resource: 'rsrc_987',
  resource_ledger_id: 'new_qbo_customer_1_id'
}
```