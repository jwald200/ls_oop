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
    (1..CARD_AMOUNT).map { Card.new }.shuffle
  end
end