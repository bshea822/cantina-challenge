require 'pry'
require 'json'

json_file = File.read('./SystemViewController.json')
json = JSON.parse(json_file)

puts "Welcome!\n\nTo begin, please enter a selector name to see the views associated with the given selector.  To exit the program, simply enter 'exit'.\n\n"

@classes = {}
@classNames = {}
@identifiers = {}

def parse_json(data)
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

input = ""
binding.pry

# while input != 'exit' do
#   print "Enter Selector: "
#   input = gets.chomp
#
#
#
# end
