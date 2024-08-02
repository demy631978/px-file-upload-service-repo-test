# https://github.com/rails/rails/issues/13971#issuecomment-383905807
# Instead raise ArgumentError, return nil as an invalid value.

module ActiveRecord
  module Enum
    class EnumType < Type::Value
      def assert_valid_value(value)
        nil unless value.blank? || mapping.key?(value) || mapping.value?(value)
      end
    end
  end
end