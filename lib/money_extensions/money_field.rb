module MoneyField
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
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
