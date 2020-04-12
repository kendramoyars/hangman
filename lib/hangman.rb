require "yaml"
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
    attr_accessor :word, :num_guesses, :num_tries, :board, :dictionary, :hidden_word, :letter_guess, :prev_guesses, :db, :filename

    def initialize
      @dictionary = load_words
      @filename = "./saved_data.yml"
      @word = select_random_word(dictionary)
      @hidden_word = create_hidden_word(word)
      @board = Board.new(hidden_word)
      @num_guesses = 9
      @num_tries = 0
      @letter_guess = ""
      @prev_guesses = []
      @db = {}
    end

    def run
    check_saved_game
    end

    def check_saved_game
      if File.exists? filename
        puts ""
        puts "Do you want to load the saved game on file? (Y/N): "
        input = gets.chomp.upcase
        if input == "Y"
          db = {}
          File.open(filename) { db = YAML.load_file(filename) }
          @num_guesses = db[:num_guesses]
          @num_tries = db[:num_tries]
          @word = db[:word]
          @hidden_word = db[:hidden_word]
          @board = Board.new(hidden_word)
          start_game
        else
        start_game
        end
      else
      start_game
      end

    end

    def start_game
      puts "#{word} - be sure to take this out ;)"
      puts ""
      puts "Let's Play Hangman!!"
      puts "You will have #{num_guesses} guesses."
      puts ""
      puts "Type 'ss' after a round to save your game!"
      puts
      board.print_board
      get_letter
    end

    def save_game
      db =  {num_guesses: num_guesses, num_tries: num_tries, word: word, hidden_word: hidden_word}
      File.open(filename, "w+") { |f| f.write(db.to_yaml) }
    end

    def get_letter
      puts "What letter would you like to guess?"
      self.letter_guess = gets.chomp

      if num_tries != 0 && letter_guess.downcase == "ss"
        save_game
      else
        verify_letter
      end
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

    game = Game.new.run
  end
end