require 'pry'
require 'json'

json_file = File.read('./SystemViewController.json')
json = JSON.parse(json_file)

@classes = {}
@classNames = {}
@identifiers = {}

def self.parse_json(data)
  data.each do |key, value|
    if key === 'class'
      if @classes[value]
        @classes[value] << data
      else
        @classes[value] = [data]
      end
    elsif key === 'classNames'
      value.each do |className|
        if @classNames[className]
          @classNames[className] << data
        else
          @classNames[className] = [data]
        end
      end
    elsif key === 'identifier'
      if @identifiers[value]
        @identifiers[value] << data
      else
        @identifiers[value] = [data]
      end
    elsif key === 'control'
      parse_json(value)
    elsif key === 'contentView' || key === 'subviews'
      if key === 'contentView'
        value['subviews'].each do |new_data|
          parse_json(new_data)
        end
      else
        value.each do |new_data|
          parse_json(new_data)
        end
      end
    end
  end
end

parse_json(json)

puts "Welcome!\n\nYou can use this program by entering in selectors to find the corresponding views!\n\nInstructions:\nEnter a selector name with a prefix symbol to pull up the corresponding views.\n\nPrefixes:\n@ = class\n. = className\n# = identifier\n\nExamples:\n@StackView - Shows all views with a class of 'StackView'\n.container - Shows all views with a CSS className of 'container'\n#videoMode - Shows all views with an identifer of 'videoMode'\n\nEnter 'exit' if you'd like to exit the program.\n\n"

input = ""

while input != 'exit' do
  print "Enter Selector: "
  input = gets.chomp
  if input[0] === '@' || input[0] === '.' || input[0] === '#'
    if input[0] === '@'
      if @classes[input.delete '@'] != nil
        @classes[input.delete '@'].each do |output|
          puts output
          puts "\n\n"
        end
      else
        puts "That selector is not found, please check your spelling and try again."
      end
    end

    if input[0] === '.'
      if @classes[input.delete '.'] != nil
        @classNames[input.delete '.'].each do |output|
          puts output
          puts "\n\n"
        end
      else
        puts "That selector is not found, please check your spelling and try again."
      end
    end

    if input[0] === '#'
      if @classes[input.delete '#'] != nil
        @identifiers[input.delete '#'].each do |output|
          puts output
          puts "\n\n"
        end
      else
        puts "That selector is not found, please check your spelling and try again."
      end
    end
  else
    puts "You did not enter a supported prefix.  Supported prefixes are '@', '.', and '#'.  Please use one of these prefixes in conjunction with a selector name."
  end
end
