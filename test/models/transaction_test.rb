require "test_helper"

describe Transaction do
  should belong_to(:bankaccount)
  should belong_to(:foreign_bankaccount)

  should validate_presence_of(:amount)
  should allow_value(0.01).for(:amount)
  should allow_value(-0.01).for(:amount)
  should_not allow_value(0.0).for(:amount)
end
