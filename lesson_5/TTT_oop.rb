require 'colorize'
require_relative 'board'
require_relative 'square'
require_relative 'player'

class TTTgame
  attr_accessor :players, :winner
  attr_reader :board

  def initialize
    @board = Board.new
    @players = []
  end

  def start_game
    init_game

    loop do
      play
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def ask_player_amount(type_of_player)
    puts "How many #{type_of_player} players?"
    gets.chomp.to_i
  end

  def add_players(type)
    amount = ask_player_amount(type)
    amount.times do
      players << (type == 'Human' ? Human : Computer).new
    end
  end

  def setup_players
    add_players('Human')
    add_players('Computer')
  end

  def init_game
    clear_screen
    display_welcome_message
    setup_players
    display_board
  end

  def play
    players.cycle do |player|
      player.move(board)
      self.winner = player if board.winner?
      display_board
      break if game_over?
    end
  end

  def game_over?
    board.full? || board.winner?
  end

  def play_again?
    puts "would you like to play again?"

    loop do
      answer = gets.chomp
      break(answer == 'y') if ['y', 'n'].include? answer
    end
  end

  def reset
    board.reset
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!\n\n"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! GoodBye!"
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_result
    display_board
    puts winner ? "#{winner.name} won!" : "it's a tie!"
  end

  def display_board
    clear_screen
    players.each { |player| print "#{player.name} is a #{player.marker}. " }
    puts "\n\n#{board}\n\n"
  end
end

TTTgame.new.start_game
