class RemoveUserFromCharityDonations < ActiveRecord::Migration[8.0]
  def change
    remove_reference :charity_donations, :user, null: false, foreign_key: true
  end
end
