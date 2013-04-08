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
    # By default it will use attribute_in_cents for cents value
    def money_field(attribute)
      module_eval <<-METHOD
        def #{attribute}
          Money.new(#{attribute}_in_cents) if #{attribute}_in_cents.present?
        end

        # Allow assigning of non money objects directly
        # Allows form data to be directly passed through
        # e.g. object.cost = '5.1'
        def #{attribute}=(money)
          self.#{attribute}_in_cents = money.try(:to_money).try(:cents)
        end
      METHOD
    end


    def money_fields(*attributes)
      attributes.each {|a| self.money_field(a)}
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
