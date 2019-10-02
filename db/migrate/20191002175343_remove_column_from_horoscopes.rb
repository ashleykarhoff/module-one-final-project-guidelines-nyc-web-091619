class RemoveColumnFromHoroscopes < ActiveRecord::Migration[5.2]
  def change
    remove_column :horoscopes, :description
  end
end
