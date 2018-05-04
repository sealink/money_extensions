module MoneyExtensions
  require 'money'
  require 'money_extensions/array'
  require 'money_extensions/big_decimal'
  require 'money_extensions/integer'
  require 'money_extensions/extensions'
  require 'money_extensions/money_field'
  require 'money_extensions/numeric'
  require 'money_extensions/string'

  # TODO: Defer requiring the active record extension to who needs it
  if Module.const_defined?('ActiveRecord')
    require 'money_extensions/active_record/extensions'
  end

end

