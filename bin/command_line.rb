class CommandLine

    def new_prompt
        TTY::Prompt.new
    end

    def zodiac_sign
        sign = new_prompt.select("Choose your new zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))
        puts ""
        puts "\u{2728}  You've chosen the Zodiac sign, #{sign}. \u{2728}"
        puts ""
        sign
    end

    def change_sign
        # Updates the user's record with the new zodiac sign
        # Will call zodiac_sign function
        User.update(User.last.id, :sign => zodiac_sign)
        homepage
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
        
        # Collect user input and create new user instance
        name = new_prompt.ask('What is your name?')
        User.create(name: name, sign: zodiac_sign)
    end

    def current_user
        User.last
    end

    def find_horoscope
        Horoscope.all.find do |scope|
            scope.sign == current_user.sign
        end
    end

    def save_horoscope?
        # ask if they want to add to favorites
        result = new_prompt.select("Would you like to save this horoscope to your favorites?", ['Yes I would!', 'No thanks..'])

        # Saves horoscope to favorites
        if result == "Yes I would!"
            Favorites.create(user_id: current_user.id, horoscope_id: find_horoscope.id)
            puts ""
            puts "\u{2728}  We've saved this horoscope to your favorites! \u{2728}"
            puts ""
        end
    end

    def show_horoscope
        # return's user's horoscope
        puts "Here is today's horoscope for #{current_user.sign}:"
        puts "~" * 40
        puts find_horoscope.horoscope

        save_horoscope?
        homepage
    end

    def find_favorites
        # Query favorites table to find user_ids matching our current user
        Favorites.where(user_id: current_user.id)
    end

    def clear_favorite_horoscopes
        find_favorites.each do |favorite|
            Favorites.delete(find_favorites)
        end
    end

    def favorite_horoscopes
        # If user hasn't saved any horoscopes, return an error message
        if find_favorites.length == 0
            puts "You haven't saved any favorites yet!"
            homepage
        end

        # Iterate through our user's favorites and query the horoscope table
        puts ""
        puts "\u{2728}  Here are your favorite horoscopes \u{2728}"

        find_favorites.each do |favorite|
            horoscopes = Horoscope.where(id: favorite.horoscope_id)

            # Print out each horoscope
            horoscopes.each do |scope|
                puts "~ " * 25
                puts ""
                puts "\u{1F52E}  " + scope.horoscope
                puts ""
            end
        end
        puts "~ " * 25

        selection = new_prompt.select('', ["Go to homepage", "Clear Favorites"])

        if selection == "Clear Favorites"
            clear_favorite_horoscopes
        end

        homepage
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