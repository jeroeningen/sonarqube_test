class CreateBankaccounts < ActiveRecord::Migration
  def change
    create_table :bankaccounts do |t|
      t.integer :user_id, default: 0, null: false
      t.decimal :balance, precision: 10, scale: 2, default: 0, null: false

      t.timestamps null: false
    end

    add_index :bankaccounts, :user_id
  end
end
