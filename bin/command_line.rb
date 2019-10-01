class CommandLine
    def greet
        prompt = TTY::Prompt.new
        name = prompt.ask('What is your name?')
        puts "Welcome, #{name}!"
        sign = prompt.select("Choose your zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))
        puts "You've selected #{sign}"

        User.create(name: name, sign: sign)

        navigate = prompt.select("Would you like to see your horoscope?", %w[yes no])

        if navigate == 'yes'
            show_horoscope
        else
            main_menu
        end
    end

    # def show_horoscope
        
    # end

    # # def main_menu

    # # end
end