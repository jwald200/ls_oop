class Participant
  include Displayable
  include Questionable
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
    in_progress_indicator("dealing #{cards.last} to you")
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
    self.name = ask("What's your name?",
                  error_msg: "Sorry, must enter a value.",
                  string: true
                )
  end

  def hit?
    ask("Would you like to (h)it or (s)tay?",
      error_msg: "Sorry, must enter 'h' or 's'.",
      options: %w(h s)
    ) == 'h'
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