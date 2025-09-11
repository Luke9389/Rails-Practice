class CreateCharityDonations < ActiveRecord::Migration[8.0]
  def change
    create_table :charity_donations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :charity_name
      t.references :expense_share, null: false, foreign_key: true

      t.timestamps
    end
  end
end
