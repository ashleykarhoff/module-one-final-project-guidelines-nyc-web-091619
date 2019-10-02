class CommandLine
    def greet

        puts "*****************************************************"
        puts "*                                                   *"
        puts "*                 Welcome to Zodiac!                *"
        puts "*                                                   *"
        puts "*****************************************************"
        puts ""
        puts "Enter your name and astrological sign to get started:"
        puts ""

        prompt = TTY::Prompt.new
        result = prompt.collect do 
            key(:name).ask('What is your name?')
            key(:sign).select("Choose your zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))
        end

        User.create(name: result[:name], sign: result[:sign])
    end

    def current_user
        User.last
    end

    def new_prompt
        TTY::Prompt.new
    end

    def show_horoscope
        # queries horoscope table for sign's horoscope
        user_horoscope = Horoscope.all.find do |scope|
            scope.sign == current_user.sign
        end

        # return's user's horoscope
        puts "Here is today's horoscope for #{current_user.sign}:"
        puts "~" * 36
        puts user_horoscope.horoscope

        # ask if they want to add to favorites
        prompt = TTY::Prompt.new
        result = prompt.select("Thank you for checking out today's horoscope! /n Would you like to save this horoscope to your favorites?", ['Yes I would!', 'No thanks..'])

        # Saves horoscope to favorites
        if result == "Yes I would!"
            Favorites.create(user_id: current_user.id, horoscope_id: user_horoscope.id)
        else 
            homepage 
        end
    end

    def change_sign
        prompt = TTY::Prompt.new
        new_sign = prompt.select("Choose your new zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))

        user_id = User.last.id
        User.update(user_id, :sign => new_sign)
        puts "You've changed your sign to #{new_sign}!"
    end

    def favorite_horoscopes
        # Query favorites table to find user_ids matching our current user
        user_favorites = Favorites.where(user_id: current_user.id)

        # If user hasn't saved any horoscopes, return an error message
        if user_favorites.length == 0
            puts "You haven't saved any favorites yet!"
        end

        # Iterate through our user's favorites and query the horoscope table
        user_favorites.each do |favorite|
            horoscopes = Horoscope.where(id: favorite.horoscope_id)

            # Print out each horoscope
            horoscopes.each do |scope|
                puts scope.horoscope
                puts "~" * 25
            end
        end
    end

    def homepage
        # Get current user
        user = current_user
        name = user.name

        puts "*****************************************************"
        puts "*                                                   *"
        puts "*                 Welcome, #{name}!                 *"
        puts "*                                                   *"
        puts "*        This is your astrological homepage         *"
        puts "*                                                   *"
        puts "*        Select an option to get started...         *"
        puts "*                                                   *"
        puts "*****************************************************"

        selection = new_prompt.select("", ["See today's horoscope", "My favorite horoscopes", "Change zodiac sign", "Delete account"])

        if selection == "See today's horoscope"
            show_horoscope
        elsif selection == "My favorite horoscopes"
            favorite_horoscopes
        elsif selection == "Change zodiac sign"
            change_sign
        else
            delete_user
        end

    end
end