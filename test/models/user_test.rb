require "test_helper"
describe User do
  should have_one(:bankaccount)
  should have_many(:transactions)

  should validate_presence_of(:firstname)
  should validate_presence_of(:lastname)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  should allow_value("test@test.nl").for(:email)
  should_not allow_value("test@test").for(:email)

  before(:each) do
    @jeroen = users(:jeroen)
    @jan = users(:jan)
    @jeroen_transferring_money = users(:jeroen_transferring_money)
    # set the balance manually, because the fixtures will not do it
    @jeroen_transferring_money.bankaccount.update_attribute :balance, @jeroen_transferring_money.transactions.sum(:amount)
  end

  it "initialize a bankaccount before validation" do
    user = User.new
    user.valid?
    assert_equal 0.0, user.bankaccount.balance
  end

  it "does not initialize a bankaccount on validation if user already has a bankaccount" do
    user = User.new
    user.bankaccount = Bankaccount.new balance: 100.0
    user.valid?
    assert_equal 100.0, user.bankaccount.balance
  end

  it "can create a user with a password" do
    # valid password match
    assert_equal true, User.create(firstname: "Test", lastname: "User", email: "testuser@domain.com", password: @default_password, password_confirmation: @default_password).errors[:password_confirmation].empty?

    # invalid password match
    assert_equal false, User.create(firstname: "Test", lastname: "User", email: "testuser2@domain.com", password: @default_password, password_confirmation: "1234").errors[:password_confirmation].empty?
    assert_equal false, User.create(firstname: "Test", lastname: "User", email: "testuser3@domain.com", password: @default_password, password_confirmation: "").errors[:password_confirmation].empty?
    assert_equal false, User.create(firstname: "Test", lastname: "User", email: "testuser4@domain.com", password: @default_password).errors[:password_confirmation].empty?

    # no password
    assert_equal false, User.create(firstname: "Test", lastname: "User", email: "testuser5@domain.com").errors[:password].empty?
  end

  it "can see their balance" do
    assert_equal "EUR. 0.00", @jeroen.current_balance
  end

  it "can deposit money and update the current balance" do
    assert_equal "U kunt geen negatief bedrag storten.", @jeroen.deposit(-0.01)
    assert_equal "U moet een bedrag opgeven.", @jeroen.deposit(0.0)
    assert_equal "U heeft EUR. 150.15 gestort.", @jeroen.deposit(150.15)
    assert_equal 1, @jeroen.transactions.count
    assert_equal 150.15, @jeroen.transactions.last.amount
    assert_equal "Gestort: EUR. 150.15", @jeroen.transactions.last.comment
    assert_equal "EUR. 150.15", @jeroen.current_balance

    # params from the controller will give a string
    assert_equal "U heeft EUR. 10.50 gestort.", @jeroen.deposit("10.50")
    assert_equal 2, @jeroen.transactions.count
    assert_equal 10.50, @jeroen.transactions.last.amount
    assert_equal "Gestort: EUR. 10.50", @jeroen.transactions.last.comment
    assert_equal "EUR. 160.65", @jeroen.current_balance
  end

  it "deposits nothing if no value given" do
    assert_equal "U moet een bedrag opgeven.", @jeroen.deposit
    assert_equal "U moet een bedrag opgeven.", @jeroen.deposit("")
    assert_equal 0, @jeroen.transactions.count
  end

  it "cannot transfer_money to other bankaccounts if the current_balance is too low" do
    # Do not transfer money if you have not enough balance
    assert_equal "U kunt geen negatief bedrag overmaken.", @jeroen.transfer_money(@jan.bankaccount.id, -0.01, "")
    assert_equal "U heeft onvoldoende saldo.", @jeroen.transfer_money(@jan.bankaccount.id, 0.01, "")
  end

  it "transfer nothing if no bankaccount or no amount given" do
    assert_equal "U moet een bankrekening opgeven.", @jeroen_transferring_money.transfer_money("", 100, "")
    assert_equal "U moet een bedrag opgeven.", @jeroen_transferring_money.transfer_money(@jan.bankaccount.id, "", "")
    assert_equal "U moet een bedrag opgeven.", @jeroen_transferring_money.transfer_money(@jan.bankaccount.id, 0.0, "")
    assert_equal 0, @jeroen.transactions.count
  end

  it "can transfer_money to other bankaccounts" do
    # deposit an amount
    assert_equal "U heeft EUR. 250.15 gestort.", @jeroen.deposit(250.15)

    # Transfer money and add transactions
    # transfer EUR. 100.00
    assert_equal "U heeft EUR. 100.00 overgemaakt naar bankrekening '#{@jan.bankaccount.id}' van #{@jan.firstname} #{@jan.lastname}.", @jeroen.transfer_money(@jan.bankaccount.id, 100.0, "Dit is commentaar")
    assert_equal "EUR. 150.15", @jeroen.current_balance
    assert_equal 2, @jeroen.transactions.count
    assert_equal -100.0, @jeroen.transactions.last.amount
    assert_equal "Dit is commentaar", @jeroen.transactions.last.comment
    assert_equal @jan.bankaccount.id, @jeroen.transactions.last.foreign_bankaccount_id
    assert_equal "EUR. 150.15", @jeroen.current_balance
    assert_equal "EUR. 100.00", @jan.current_balance
    assert_equal 1, @jan.transactions.count
    assert_equal 100.0, @jan.transactions.last.amount
    assert_equal @jeroen.bankaccount.id, @jan.transactions.last.foreign_bankaccount_id
    assert_equal "Dit is commentaar", @jan.transactions.last.comment

    # transfer EUR. 150.15, params from the contrller will give a string
    assert_equal "U heeft EUR. 150.15 overgemaakt naar bankrekening '#{@jan.bankaccount.id}' van #{@jan.firstname} #{@jan.lastname}.", @jeroen.transfer_money(@jan.bankaccount.id, "150.15", "Dit is nog meer commentaar")
    assert_equal "EUR. 0.00", @jeroen.current_balance
    assert_equal 3, @jeroen.transactions.count
    assert_equal -150.15, @jeroen.transactions.last.amount
    assert_equal @jan.bankaccount.id, @jeroen.transactions.last.foreign_bankaccount_id
    assert_equal "Dit is nog meer commentaar", @jeroen.transactions.last.comment
    assert_equal "EUR. 0.00", @jeroen.current_balance
    assert_equal "EUR. 250.15", @jan.current_balance
    assert_equal 2, @jan.transactions.count
    assert_equal 150.15, @jan.transactions.last.amount
    assert_equal @jeroen.bankaccount.id, @jan.transactions.last.foreign_bankaccount_id
    assert_equal "Dit is nog meer commentaar", @jan.transactions.last.comment
  end
end
