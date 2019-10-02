class CommandLine

    def new_prompt
        TTY::Prompt.new
    end

    def greet
        # Print out a welcome message to the screen
        puts "~ " * 32
        puts "~                                                             ~"
        puts "~                                                             ~"
        puts "~                    Welcome to Zodiac! \u{1F319}                     ~"
        puts "~                                                             ~"
        puts "~    Enter your name and astrological sign to get started:    ~"
        puts "~                                                             ~"
        puts "~                                                             ~"
        puts "~ " * 32
        puts ""
        
        # Collect user input
        result = new_prompt.collect do 
            key(:name).ask('What is your name?')
            key(:sign).select("Choose your zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))
        end

        # Create new DB user instance
        User.create(name: result[:name], sign: result[:sign])

    end

    def current_user
        User.last
    end

    def show_horoscope
        # queries horoscope table for sign's horoscope
        user_horoscope = Horoscope.all.find do |scope|
            scope.sign == current_user.sign
        end

        # return's user's horoscope
        puts "Here is today's horoscope for #{current_user.sign}:"
        puts "~" * 40
        puts user_horoscope.horoscope

        # ask if they want to add to favorites
        result = new_prompt.select("Thank you for checking out today's horoscope! /n Would you like to save this horoscope to your favorites?", ['Yes I would!', 'No thanks..'])

        # Saves horoscope to favorites
        if result == "Yes I would!"
            Favorites.create(user_id: current_user.id, horoscope_id: user_horoscope.id)
        else 
            homepage 
        end
    end

    def change_sign
        new_sign = new_prompt.select("Choose your new zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))

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
                puts ""
                puts "~" * 25
            end
        end
    end

    def homepage
        # Get current user
        name = current_user.name

        puts "~ " * 32
        puts "~                                                             ~"
        puts "Hi, #{name}!"
        puts "~                                                             ~"
        puts "~" + "  " * 7 + "\u{1F52E}   Welcome to Zodiac's Homepage  \u{1F52E}" + "  " * 7 + "~"
        puts "~                                                             ~"
        puts "~ " * 32

        selection = new_prompt.select("", ["See today's horoscope", "Learn about my sign", "My favorite horoscopes", "Change zodiac sign"])

        if selection == "See today's horoscope"
            show_horoscope
        elsif selection == "My favorite horoscopes"
            favorite_horoscopes
        elsif selection == "Learn about my sign"
            sign_info
        else
            change_sign 
        end

    end
end