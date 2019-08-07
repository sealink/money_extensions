# frozen_string_literal: true

class Array
  # Returns sum as a money - and returns 0 for empty arrays
  def total_money
    empty? ? ::Money.new(0) : inject(:+)
  end
end
