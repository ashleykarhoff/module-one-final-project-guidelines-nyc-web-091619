class CreateHoroscopesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :horoscopes do |t|
      t.string :sign
      t.string :horoscope
    end
  end
end
