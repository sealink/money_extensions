Money Extensions 
================

[![Build Status](https://travis-ci.org/sealink/money_extensions.png?branch=master)](https://travis-ci.org/sealink/money_extensions)
[![Coverage Status](https://coveralls.io/repos/sealink/money_extensions/badge.png)](https://coveralls.io/r/sealink/money_extensions)
[![Dependency Status](https://gemnasium.com/sealink/money_extensions.png?travis)](https://gemnasium.com/sealink/money_extensions)
[![Code Climate](https://codeclimate.com/github/sealink/money_extensions.png)](https://codeclimate.com/github/sealink/money_extensions)

# DESCRIPTION

Extends the money classes with helpful functions and currency functions

e.g. in model
money_fields :total, :discount

This will by default map a money object "total" to a database column total_in_cents and the same for discount.

Various numerical functions for money, e.g. round, split_between, sign, etc.

See spec directory for examples.

# INSTALLATION

Add to your Gemfile:
gem 'money_extensions'

