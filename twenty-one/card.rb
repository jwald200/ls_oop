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