module Questionable
  def prompt(msg)
    puts "=> #{msg}"
  end

  def ask(question, validation_msg = nil)
    answer = nil
    loop do
      prompt question
      answer = gets.chomp
      break if !block_given? || yield(answer)
      prompt validation_msg if validation_msg
    end
    answer
  end
end

class Player
  attr_accessor :name, :move, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  include Questionable

  def set_name
    question = "What's your name?"
    validation_msg = "Sorry, we didn't get that."

    self.name = ask(question, validation_msg) { |answer| !answer.empty? }
  end

  def choose
    question = 'Please choose rock, paper, or scissors:'
    validation_msg = 'Sorry, invalid choice'

    choice = ask(question, validation_msg) do |answer|
               %w(rock paper scissors).include?(answer)
             end

    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w(RW33 SW55 AD67).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = %w(rock paper scissors)

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def ==(other_move)
    value == other_move.value
  end
end

class RPSGame
  ROUNDS_TO_WIN = 5
  include Questionable
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    prompt "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    prompt "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    prompt "#{human.name} chose #{human.move.value}"
    prompt "#{computer.name} chose #{computer.move.value}"
  end

  def detect_winner
    if human.move != computer.move
      (human.move > computer.move) ? :player : :computer
    end
  end

  def display_winner
    case detect_winner
    when :player then prompt "You won!"
    when :computer then prompt "#{computer.name} won!"
    else; prompt "It's a tie!"
    end
  end

  def update_scores!
    winner = detect_winner

    if winner == :player
      human.score += 1
    elsif winner == :computer
      computer.score += 1
    end
  end

  def display_score
    prompt "player score: #{human.score}"
    prompt "computer score: #{computer.score}"
  end

  def game_over?
    human.score == ROUNDS_TO_WIN || computer.score == ROUNDS_TO_WIN
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def play_again?
    question = "Would you like to play again? (Y/N)"
    answer = ask(question)
    answer.downcase.start_with? 'y'
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      update_scores!
      display_moves
      display_winner
      display_score
      if game_over?
        reset_score
        break unless play_again?
      end
    end
    display_goodbye_message
  end
end

RPSGame.new.play
