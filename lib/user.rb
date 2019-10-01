class User < ActiveRecord::Base
    has_many :horoscopes
    has_many :horoscopes, through: :favorites
end