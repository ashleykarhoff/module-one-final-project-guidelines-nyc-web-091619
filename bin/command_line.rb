class CommandLine
    def greet
        prompt = TTY::Prompt.new
        result = prompt.collect do 
            key(:name).ask('What is your name?')
            
            key(:sign).select("Choose your zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))
        end

        User.create(name: result[:name], sign: result[:sign])
    end

    def show_horoscope
        # find a new user's id
        user_id = User.last.id

        # returns user's sign as a string
        user_sign = User.find_by(id: user_id).sign

        # queries horoscope table for sign's horoscope
        user_horoscope = Horoscope.all.find do |scope|
            scope.sign == user_sign
        end

        # return's user's horoscope
        puts user_horoscope.horoscope

        # ask if they want to add to favorites
        prompt = TTY::Prompt.new
        result = prompt.select("Would you like to save your horoscope?", %w(yes no))

        if result == 'yes'
            Favorites.create(user_id: user_id, horoscope_id: user_horoscope.id)
        end
    end

    def change_sign
        prompt = TTY::Prompt.new
        new_sign = prompt.select("Choose your zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))

        user_id = User.last.id
        User.update(user_id, :sign => new_sign)
        puts "You've changed your sign to #{new_sign}!"
    end

end