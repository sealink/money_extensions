# Money Extensions

[![Gem Version](https://badge.fury.io/rb/money_extensions.svg)](http://badge.fury.io/rb/money_extensions)
[![Build Status](https://github.com/sealink/money_extensions/workflows/Build%20and%20Test/badge.svg?branch=master)](https://github.com/sealink/money_extensions/actions)
[![Coverage Status](https://coveralls.io/repos/sealink/money_extensions/badge.png)](https://coveralls.io/r/sealink/money_extensions)
[![Code Climate](https://codeclimate.com/github/sealink/money_extensions.png)](https://codeclimate.com/github/sealink/money_extensions)

# DESCRIPTION

Extends the money classes with helpful functions and currency functions

e.g. in model

```ruby
money_fields :total, :discount
```

This will by default map a money object "total" to a database column total_in_cents and the same for discount.

Various numerical functions for money, e.g. round, split_between, sign, etc.

See spec directory for examples.

# INSTALLATION

Add to your Gemfile:
gem 'money_extensions'

# RELEASE

To publish a new version of this gem the following steps must be taken.

- Update the version in the following files
  ```
    CHANGELOG.md
    lib/quick_travel/version.rb
  ```
- Create a tag using the format v0.1.0
- Follow build progress in GitHub actions
