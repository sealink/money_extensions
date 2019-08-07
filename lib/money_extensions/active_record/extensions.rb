# frozen_string_literal: true

module ActiveRecord
  module Extensions
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

        composed_of attr_name, class_name: 'Money::Currency',
                               mapping: [field_name, 'iso_code'],
                               allow_nil: true,
                               constructor: proc { |value| Money::Currency.new(value) unless value.blank? }

        scope :for_currency, lambda { |currency|
                               where(currency_iso_code: currency.iso_code)
                             }

        if options[:default]
          before_validation :set_default_currency
          class_eval <<-METHOD
          def set_default_currency
            self.currency ||= EnabledCurrency.base_currency
            true
          end
          METHOD
        end

        validates_presence_of :currency_iso_code if options[:required]
      end
    end
  end
end

::ActiveRecord::Base.send(:include, MoneyField)
::ActiveRecord::Base.send(:include, ActiveRecord::Extensions)
