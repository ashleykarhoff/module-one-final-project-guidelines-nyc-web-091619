class Favorites < ActiveRecord::Base
    belongs_to :horoscope
    belongs_to :user
end