require_relative 'questionable'
require_relative 'displayable'
require_relative 'outcome'
require_relative 'card'
require_relative 'deck'
require_relative 'participant'

class TwentyOne
  include Questionable
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
    ask("Would you like to play again? (y/n)",
      error_msg: "Sorry, must be y or n.",
      options: %w(y n)
    ) == 'y'
  end

  def reset
    deck.reset
    participants.each(&:reset)
  end
end

TwentyOne.new.start
