class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname, default: "", null: false
      t.string :lastname, default: "", null: false
      t.string :email, default: "", null: false
      t.string :password_digest, default: "", null: false

      t.timestamps null: false
    end
  end
end
