require 'json'

class Hangman
	def initialize
		puts "Welcome to Hangman!"
		puts "Please enter 'new game' or 'load game':"

		new_or_load = gets.chomp
		while new_or_load != 'new game' && new_or_load != 'load game'
			puts "Invalid entry. Please enter 'new game' or 'load game':"
			new_or_load = gets.chomp
		end

		if new_or_load == 'new game'
			self.new_game
		else
			puts "Please enter the filename: "
			filename = gets.chomp
			load(filename)
			puts "Welcome back! You have #{@remaining_guesses} remaining guesses."
		end

		puts ""
	end

	def new_game
		@word = self.random_word
		@remaining_guesses = 5
		@incorrect_letters = []
		@correct_letters = []
		@word.split("").each {|x| @correct_letters << "_"}
	end

	def random_word
		words = File.readlines "5desk.txt"
		numberOfWords = words.size
		chosenWord = ""

		while (chosenWord.size < 5) || (chosenWord.size > 12)
			chosenWord = words[rand(numberOfWords)%numberOfWords]
		end

		chosenWord.strip
	end

	def play
		while(!game_over?)
			self.current_turn
		end
	end

	def current_turn
		puts @correct_letters.join
		puts "Incorrect Letters: #{@incorrect_letters.join(" ")}"
		puts "Please enter a character or 'save' to save your game:"
		userGuess = gets.chomp.downcase

		while userGuess.size != 1
			if userGuess == 'save'
				save
				puts "Your game has been saved."
				puts "Please enter a character: "
			else
				puts "Invalid entry, please enter a character or 'save': "
			end
			userGuess = gets.chomp
		end


		found_positions = (0...@word.length).find_all {|i| @word[i].downcase == userGuess}

		if found_positions.empty?
			@remaining_guesses -= 1
			@incorrect_letters << userGuess
			puts "Incorrect! #{userGuess} is not in the word! #{@remaining_guesses} remaining guesses!"
		else
			puts "Correct! #{userGuess} is in the word!"
			found_positions.each {|i| @correct_letters[i] = @word.split("")[i]}
		end

		puts ""
	end

	def game_over?
		if @remaining_guesses == 0
			puts "You have exceeded 5 attempts. The correct word was: #{@word}"
			true
		elsif @correct_letters.join == @word
			puts "You have won the game of hangman!"
			true
		else
			false
		end
	end

	def save
		save_hash = {
			:word => @word,
			:remaining_guesses => @remaining_guesses,
			:incorrect_letters => @incorrect_letters,
			:correct_letters => @correct_letters
			}

		File.open("savefile.json", "w") do |file|
			file.write(save_hash.to_json)
		end
	end

	def load(text_name)
		file = File.read(text_name)
		data = JSON.parse(file)
		@word = data['word']
		@remaining_guesses = data['remaining_guesses']
		@incorrect_letters = data['incorrect_letters']
		@correct_letters = data['correct_letters']
	end
end

myHangmanGame = Hangman.new
myHangmanGame.play