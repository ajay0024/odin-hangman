class Game
  def select_word
    words = File.readlines("google-10000-english-no-swears.txt")
    x = ""
    until x.length <= 12 && x.length >= 5
      x = words.sample.chomp.downcase
    end
    x
  end

  def play_game
    puts @secret_word
    display_result
    until @game_over
        print "\n"
        print "Enter 'S' to save the game or press Enter to continue the game."
        option = gets.chomp.downcase[0]
        if option == 's'
            save_game
            break
        end
        chosen_character = nil
        until chosen_character
            print "Enter a character : "
            chosen_character = gets.chomp.downcase[0]
            puts chosen_character ? "You chose '#{chosen_character}'" : "You did not enter valid character"
        end
        unless @chosen_characters.include?(chosen_character)
            @chosen_characters << chosen_character
            @remaining_turns -=1 unless @secret_word.include?(chosen_character) 
        else
            puts "'#{chosen_character}' character has already been choosen by you!"
        end
        display_result
    end
  end

  def display_result
    @secret_word.split("").each_with_index do |y,idx|
        if @chosen_characters.include?(y)
            @current_result[idx] = y
        end
    end
    puts "#{@current_result.join""} "
    if !@current_result.include?("_")
        @game_over = true
        puts "You won the Game!"
    elsif @remaining_turns == 0
        @game_over = true
        puts "You Lost! No more attempts remaining! The correct word was #{@secret_word}"
    else
        puts "You have #{@remaining_turns} attempts remaining"
    end
  end

  def save_game
    x = Marshal.dump(self)
    File.open("save.txt","w") {|f| f.write(x)}
  end

  def initialize()
    @secret_word = select_word
    @game_over = false
    @remaining_turns = 11
    @chosen_characters= []
    @current_result = Array.new(@secret_word.length, "_")
  end
end

x = ""
if File.exist?("save.txt")
    print("Do you want to load previous Save? Press 'L' to load and 'C' to continue: ")
    x = gets.chomp.downcase[0]
end
game  = x=="l"? Marshal.load(File.read("save.txt")) : Game.new()
game.play_game
