require 'pry'
require_relative 'clquestion'
require_relative 'displayable'
require_relative 'outcome'

class Card
  SUITS = %w(Hearts Diamonds Spades Clubs).freeze
  FACES = [*2..10] + %w(Jack Queen King Ace).freeze
  @values = SUITS.product(FACES).cycle
  attr_reader :suit, :face

  def initialize
    @suit, @face = self.class.values
  end

  def ace?
    face == 'Ace'
  end

  def number?
    (2..10) === face
  end

  def self.values
    @values.next
  end

  def to_s
    "The #{face} of #{suit}"
  end
end

class Deck
  CARD_AMOUNT = 52
  attr_accessor :cards

  def initialize
    @cards = init_cards
  end

  def reset
    self.cards = init_cards
  end

  def deal_card
    cards.pop
  end

  private

  def init_cards
    [].tap do |cards|
      CARD_AMOUNT.times { cards << Card.new }
    end.shuffle
  end
end

class Participant
  include Displayable

  attr_accessor :cards, :name

  def initialize
    self.cards = []
    set_name
  end

  def add_card(deck)
    cards << deck.deal_card
  end

  def total
    total = 0
    cards.each do |card|
      total += case
               when card.number? then card.face
               when card.ace? then 11
               else 10
               end
    end

    adjust_aces(total)
  end

  def busted?
    total > TwentyOne::VALUES_TO_WIN
  end

  def won_or_busted?
    total >= TwentyOne::VALUES_TO_WIN
  end

  def show_hand
    puts "---- #{name}'s Hand ----"

    cards.each { |card| prompt card }

    prompt "Total: #{total}\n\n"
  end

  private

  def hit(deck)
    add_card(deck)
    in_progress_indicator("dealing a #{cards.last} to you")
    clear
    show_hand
  end

  def adjust_aces(total)
    cards.each do |card|
      break if total <= TwentyOne::VALUES_TO_WIN
      card.ace? ? total -= 10 : next
    end
    total
  end
end

class Player < Participant
  attr_accessor :stay

  def show_flop
    show_hand
  end

  def turn(deck)
    until turn_over?
      hit? ? hit(deck) : self.stay = true
    end

    puts "You chose to stay." if stay?
  end

  def turn_over?
    stay? || total >= TwentyOne::VALUES_TO_WIN
  end

  def reset
    self.stay = false
    self.cards = []
  end

  private

  def set_name
    self.name = CLquestion.ask("What's your name?") do |q|
                  q.error_msg = "Sorry, must enter a value."
                  q.string = true
                end
  end

  def hit?
    CLquestion.ask("Would you like to (h)it or (s)tay?") do |q|
      q.error_msg = "Sorry, must enter 'h' or 's'."
      q.options = %w(h s)
    end == 'h'
  end

  def stay?
    !!stay
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].freeze

  def show_flop
    puts "---- #{name}'s Hand ----"
    prompt cards.first
    puts " ?? \n\n"
  end

  def turn(deck)
    until turn_over?
      hit(deck)
      sleep 1
    end
  end

  def turn_over?
    total >= TwentyOne::DEALER_MINIMUM
  end

  def reset
    self.cards = []
  end

  private

  def set_name
    self.name = ROBOTS.sample
  end
end

class TwentyOne
  include Displayable
  include Outcome
  VALUES_TO_WIN = 21
  DEALER_MINIMUM = 17

  attr_reader :deck, :participants

  def initialize
    @deck = Deck.new
    @participants = [Player.new, Dealer.new]
  end

  def start
    display_welcome
    loop do
      in_progress_indicator("dealing the cards")
      clear
      deal_cards
      participants.each(&:show_flop)
      participants_turn
      clear
      participants.each(&:show_hand)
      display_outcome
      play_again? ? reset : break
    end
    puts "Thank you for playing Twenty-One. Goodbye!"
  end

  private

  def display_welcome
    clear
    prompt "Welcome to Twenty-one!\n\n"
  end

  def deal_cards
    participants.cycle(2) do |participant|
      participant.add_card(deck)
    end
  end

  def participants_turn
    participants.each do |participant|
      prompt "#{participant.name}'s turn'"
      participant.turn(deck)
      break if participant.won_or_busted?
      sleep 1
      clear
    end
  end

  def play_again?
    CLquestion.ask("Would you like to play again? (y/n)") do |q|
      q.error_msg = "Sorry, must be y or n."
      q.options = %w(y n)
    end == 'y'
  end

  def reset
    deck.reset
    participants.each(&:reset)
  end
end
TwentyOne.new.start
