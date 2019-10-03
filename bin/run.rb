require 'pry'

require_relative '../config/environment'
require_relative 'command_line.rb'

system "clear"

new_cli = CommandLine.new 
new_cli.greet
new_cli.homepage

# binding.pry

#new_cli.change_sign
