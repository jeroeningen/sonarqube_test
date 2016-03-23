require "test_helper"

describe Bankaccount do
  should belong_to(:user)
  should have_many(:transactions)

  should validate_numericality_of(:balance).is_greater_than_or_equal_to(0.0)
end
