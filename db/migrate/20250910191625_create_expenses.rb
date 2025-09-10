class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :description
      t.decimal :amount
      t.references :paid_by, null: false, foreign_key: { to_table: :users }
      t.date :date

      t.timestamps
    end
  end
end
