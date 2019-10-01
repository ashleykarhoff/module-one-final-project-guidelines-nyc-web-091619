class CommandLine
    def greet
        puts "What is your name?"
        name = gets.chomp
        puts "What month were you born?"
        month = gets.chomp 
        puts "What day were you born?"
        day = gets.chomp 

        User.new(name: name, month: month, day: day)
    end
end