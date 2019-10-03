class CommandLine
 
    def new_prompt
        # TTY::Prompt.new
        TTY::Prompt.new(active_color: :magenta)
    end

    def sound_effect
        pid = fork{ exec 'afplay', 'fantasy_sound_effect.mp3'}
    end

    def typing_effect(string)
        string.split("").each do |c|
            print c 
            sleep(0.025)
        end
    end

    def pastel
        pastel = Pastel.new
    end

    def zodiac_sign
        sign = new_prompt.select("Choose your new zodiac sign:", %w(Aquarius Pisces Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn))
        puts ""
        typing_effect("\u{2728}  You've chosen the Zodiac sign, #{sign}. \u{2728}")
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
        # Start sound effect
        sound_effect

        # Print out a welcome message to the screen
        puts pastel.bright_magenta("                                                                                                                                         
ZZZZZZZZZZZZZZZZZZZ          OOOOOOOOO          DDDDDDDDDDDDD             IIIIIIIIII                    AAA                            CCCCCCCCCCCCC
Z:::::::::::::::::Z        OO:::::::::OO        D::::::::::::DDD          I::::::::I                   A:::A                        CCC::::::::::::C
Z:::::::::::::::::Z      OO:::::::::::::OO      D:::::::::::::::DD        I::::::::I                  A:::::A                     CC:::::::::::::::C
Z:::ZZZZZZZZ:::::Z      O:::::::OOO:::::::O     DDD:::::DDDDD:::::D       II::::::II                 A:::::::A                   C:::::CCCCCCCC::::C
ZZZZZ     Z:::::Z       O::::::O   O::::::O       D:::::D    D:::::D        I::::I                  A:::::::::A                 C:::::C       CCCCCC
        Z:::::Z         O:::::O     O:::::O       D:::::D     D:::::D       I::::I                 A:::::A:::::A               C:::::C              
       Z:::::Z          O:::::O     O:::::O       D:::::D     D:::::D       I::::I                A:::::A A:::::A              C:::::C              
      Z:::::Z           O:::::O     O:::::O       D:::::D     D:::::D       I::::I               A:::::A   A:::::A             C:::::C              
     Z:::::Z            O:::::O     O:::::O       D:::::D     D:::::D       I::::I              A:::::A     A:::::A            C:::::C              
    Z:::::Z             O:::::O     O:::::O       D:::::D     D:::::D       I::::I             A:::::AAAAAAAAA:::::A           C:::::C              
   Z:::::Z              O:::::O     O:::::O       D:::::D     D:::::D       I::::I            A:::::::::::::::::::::A          C:::::C              
ZZZ:::::Z     ZZZZZ     O::::::O   O::::::O       D:::::D    D:::::D        I::::I           A:::::AAAAAAAAAAAAA:::::A          C:::::C       CCCCCC
Z::::::ZZZZZZZZ:::Z     O:::::::OOO:::::::O     DDD:::::DDDDD:::::D       II::::::II        A:::::A             A:::::A          C:::::CCCCCCCC::::C
Z:::::::::::::::::Z      OO:::::::::::::OO      D:::::::::::::::DD        I::::::::I       A:::::A               A:::::A          CC:::::::::::::::C
Z:::::::::::::::::Z        OO:::::::::OO        D::::::::::::DDD          I::::::::I      A:::::A                 A:::::A           CCC::::::::::::C
ZZZZZZZZZZZZZZZZZZZ          OOOOOOOOO          DDDDDDDDDDDDD             IIIIIIIIII     AAAAAAA                   AAAAAAA             CCCCCCCCCCCCC")
        
        puts ""
        puts ""
        puts "\u{2728} " * 32
        puts "\u{2728}                                                             \u{2728}"
        puts "\u{2728}                                                             \u{2728}"
        puts "\u{2728}                    Welcome to Zodiac! \u{1F319}                     \u{2728}"
        puts "\u{2728}                                                             \u{2728}"
        puts "\u{2728}    Enter your name and astrological sign to get started:    \u{2728}"
        puts "\u{2728}                                                             \u{2728}"
        puts "\u{2728}                                                             \u{2728}"
        puts "\u{2728} " * 32
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

    def sign_info
        puts ""
        puts "\u{2728}   Learn more about the #{current_user.sign} sign \u{2728}"
        puts ""
        puts "\u{1F319}  " + find_horoscope.description

        homepage
    end

    def exit_app
        puts "\u{2728}  Thank you for using Zodiac! Come back soon \u{2728}"
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
        else
            exit_app
        end
    end

    def show_horoscope
        # return's user's horoscope
        puts ""
        puts "\u{2728}  Here is today's horoscope for #{current_user.sign}: \u{2728}"
        puts ""
        typing_effect(find_horoscope.horoscope)
        puts ""

        save_horoscope?
        puts ""

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
                puts ""
                puts "\u{1F52E}  " + scope.horoscope
                puts ""
            end
        end

        selection = new_prompt.select('', ["Go to homepage", "Clear Favorites"])

        if selection == "Clear Favorites"
            clear_favorite_horoscopes
        end

        homepage
    end

    def homepage
        # Get current user
        name = current_user.name

        puts ""
        puts "\u{1F52E}  " + pastel.underline("Zodiac Menu")

        selection = new_prompt.select("", ["See today's horoscope", "Learn about my sign", "My favorite horoscopes", "Change zodiac sign", "Exit Zodiac"])

        if selection == "See today's horoscope"
            show_horoscope
        elsif selection == "My favorite horoscopes"
            favorite_horoscopes
        elsif selection == "Learn about my sign"
            sign_info
        elsif selection == "Change zodiac sign"
            change_sign
        else
            exit_app
        end

    end
end