module Hangman

class player

end

class Board
  
end

class Game

end
puts "Hangman Initialized!"

dictionary = File.open("5desk.txt", "r")
while !dictionary.eof?
  line = dictionary.readline
  puts line
end


end