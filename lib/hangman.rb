module Hangman

  class Board
    attr_accessor :word

    def initialize(word)
      @word = word

    end

    def display_word(word)
      word.each {|x| print x + ' '}
      puts ""
    end

    def print_board
      display_word(word)
      puts ""
    end
  end

  class Game
    attr_accessor :word, :num_guesses, :num_tries, :board, :dictionary, :hidden_word, :letter_guess, :prev_guesses

    def initialize
      @dictionary = load_words
      @word = select_random_word(dictionary)
      @hidden_word = create_hidden_word(word)
      @board = Board.new(hidden_word)
      @num_guesses = 9
      @num_tries = 0
      @letter_guess = ""
      @prev_guesses = []
    end

    def start_game
      #if a file exists ask if we want to load that file - add this in later.
      puts "#{word} - be sure to take this out ;)"
      puts ""
      puts "Let's Play Hangman!!"
      puts "You will have #{num_guesses} guesses."
      board.print_board
      get_letter
      
    end

    def get_letter
      puts "What letter would you like to guess?"
      self.letter_guess = gets.chomp
      verify_letter
    end

    def verify_letter
      if letter_guess.length == 1 && letter_guess[/[a-zA-Z]+/]
        self.num_tries += 1
        prev_guesses << letter_guess.upcase
        check_guess
      else
        puts ""
        puts "Please only choose one letter."
        puts ""
        get_letter
      end
    end

    def compare_letter
      match_found = false
      word_array = word.split("")
      word_array.each_with_index do |letter, index|
        if letter == letter_guess.upcase && hidden_word[index] != (letter)
          hidden_word[index] = letter
          match_found = true
        end
      end
      match_found
    end

    def check_guess
      guess_right = false
      if num_guesses > 1 
        if compare_letter
          guess_right = true
          puts ""
          puts " [✓] You found #{hidden_word.count(letter_guess.upcase)} matches! You have #{num_guesses} guesses left!'"
          print_feedback(guess_right)
        else
          self.num_guesses -= 1
          puts ""
          puts " [X] No match for '#{letter_guess}'. You have #{num_guesses} guesses left!'"
          print_feedback(guess_right)
        end
      else
        puts ""
        puts "Sorry, you are out of guesses!"
        puts "Do you want to see the word? Enter: (Y/N)"
        puts ""
        see_word_input = gets.chomp
        see_word(see_word_input)
      end
    end

    def print_feedback(guess_right)
      board.print_board
      puts ""
      puts "Previous guesses: #{prev_guesses.join(", ")}"
      puts ""
      if guess_right
        check_win
      else
        get_letter
      end
    end

    def see_word(response)
      if response.upcase == 'Y'
        puts ""
        puts "The word was: #{word}."
      else
        puts ""
        puts "Okay, bye!"
      end
    end

    def check_win
      if word.split("") == hidden_word
        puts ""
        puts "YOU WIN!!!!"
      else
        get_letter
      end
    end

    def load_words
      # we could possibly shorten the code in this function
      dictionary = File.open("5desk.txt") {|x| x.readlines}
      dictionary.map! {|word| word.upcase.strip}
      dictionary.select! {|word| word.length >= 5 && word.length <= 12}
      dictionary
    end

    def select_random_word(dict)
      dict.sample
    end

    def create_hidden_word(word)
      Array.new(word.length) {"_"}
    end

    game = Game.new.start_game
  end
end