module MoneyField
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Assign a :currency (Money::Currency object) reader/writer for the given
    # field name.
    #
    # NOTES:
    # * Currency is identified by a 3-letter ISO code,
    # * Lookup is doen via Money::Currency.find(iso_code)
    def has_currency(*args)
      options = args.extract_options!
      attr_name = args.first || :currency

      field_name = "#{attr_name}_iso_code"
      
      composed_of attr_name, :class_name => "Money::Currency",
                             :mapping => [field_name, 'iso_code'],
                             :allow_nil => true,
                             :constructor => Proc.new{|value| Money::Currency.new(value) unless value.blank?}

      if Rails.version > '3'
        scope :for_currency, lambda{ |currency|
          where(:currency_iso_code => currency.iso_code)
        }
      else
        named_scope :for_currency, lambda{ |currency|
          {:conditions => {:currency_iso_code => currency.iso_code}}
        }
      end

      if options[:default]
        before_validation :set_default_currency
        class_eval <<-METHOD
          def set_default_currency
            self.currency ||= EnabledCurrency.base_currency
            true
          end
        METHOD
      end

      if options[:required]
        validates_presence_of :currency_iso_code
      end
    end


    # Add a money field attribute
    #
    # By default it will use attribute_in_cents as db field, but this can
    # be overridden by specifying :db_field => 'somthing_else'
    def money_field(attribute, options={})
      db_field = options[:db_field] || attribute.to_s + '_in_cents'
      self.composed_of(attribute,
        :class_name => "Money",
        :allow_nil  => true,
        :mapping    => [[db_field, 'cents']],
        :converter  => Proc.new {|field| field.to_money}
      )
    end


    def money(*fields)
      fields.each do |field|
        class_eval <<-METHOD
          def #{field}
            Money.new(#{field}_in_cents)
          end
        METHOD
      end
    end


    def money_fields(*attributes)
      opts = attributes.extract_options!
      attributes.each {|a| self.money_field(a, opts)}
    end
  end
end


class String
  # Converts this string to a float and then to a Money object in the default currency. 
  # It multiplies the converted numeric value by 100 and treats that as cents.
  #
  # NOTE!!!
  # This is overriden as per the default Money .to_money because it assumes
  # a different default currency...
  #
  # '100'.to_money => #<Money @cents=10000>
  # '100.37'.to_money => #<Money @cents=10037>
  def to_money(currency = nil)
    Money.new((self.to_f * 100).round, currency)
  end
end
