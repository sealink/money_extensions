# frozen_string_literal: true

module MoneyField
  extend ActiveSupport::Concern

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
      attributes.each { |a| money_field(a) }
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
