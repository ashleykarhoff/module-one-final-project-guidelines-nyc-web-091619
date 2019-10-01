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
        # find this new user's id
        user_id = User.last.id

        # returns user's sign as a string
        user_sign = User.find_by(id: user_id).sign

        # queries horoscope table for sign's horoscope
        user_horoscope = Horoscope.all.find do |scope|
            scope.sign == user_sign
        end

        # return's user's horoscope
        puts user_horoscope.horoscope
    end

end