module MoneyExtensions
  VERSION = '0.0.1'

  require 'money'
  require 'money_extensions/money_extensions'
  require 'money_extensions/big_decimal'

  require 'money_extensions/money_field'

  # TODO: Defer requiring the active record extension to who needs it
  if Module.const_defined?('ActiveRecord')
    require 'money_extensions/active_record/extensions'
  end

end

