class Player
  @@markers = Square::VALID_MARKERS.each
  attr_accessor :name, :marker

  def initialize
    set_name
    @marker = @@markers.next
  end
end

class Human < Player
  @players = 0
  
  def Human.players
    @players
  end
  
  def Human.add_to_player_count
    @players += 1
  end
  
  def initialize
    super()
    Human.add_to_player_count
  end

  def set_name
    msg = if Human.players > 0
            "next player's name?"
          else
            "What's your name?"
          end
    puts msg

    loop do
      answer = gets.chomp
      self.name = answer unless answer.empty?
      break if name
    end
  end

  def move(board)
    puts "#{name}, It's your turn."
    key = loop do
            answer = gets.chomp.to_i
            break(answer) if board.unmarked_squares.include?(answer)
            puts 'Sorry, invalid choice'
          end
    board[key] = marker
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2R7 JK09 MAIN).sample
  end

  def move(board)
    board[board.unmarked_squares.sample] = marker
  end
end
