class CreateExpenseShares < ActiveRecord::Migration[8.0]
  def change
    create_table :expense_shares do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount_owed

      t.timestamps
    end
  end
end
