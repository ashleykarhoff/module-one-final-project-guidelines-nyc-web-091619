class AddDescriptionColumnToHoroscopes < ActiveRecord::Migration[5.2]
  def change
    add_column :horoscopes, :description, :text
  end
end
