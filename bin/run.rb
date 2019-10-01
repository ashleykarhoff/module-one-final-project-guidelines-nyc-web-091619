require 'pry'

require_relative '../config/environment'
require_relative 'command_line.rb'

new_cli = CommandLine.new 
new_cli.greet
new_cli.show_horoscope
new_cli.change_sign
