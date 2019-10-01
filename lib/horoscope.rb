class Horoscope < ActiveRecord::Base
    has_many :users
    has_many :users, through: :favorites
end