class Board
  BOARD_SIZE = 6
  SQUARES_TO_WIN = 4
  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def reset
    (1..BOARD_SIZE**2).each do |index|
      squares[index] = Square.new(index.to_s.light_black)
    end
  end

  def unmarked_squares
    squares.select { |_, square| square.unmarked? }.keys
  end

  def []=(key, marker)
    squares[key].marker = marker
  end

  def full?
    unmarked_squares.empty?
  end

  def winner?
    !!winning_line
  end

  def to_s
    color_green(winning_line) if winner?

    str = ''
    squares.each do |idx, square|
      str += format_square(square)
      str += square_delimiter(idx)
      str += row_delimiter if before_new_row?(idx)
    end
    str
  end

  private

  # outcome helpers

  def next_square_index(type)
    case type
    when :rows then 1
    when :columns then BOARD_SIZE
    when :reverse_diagonal then BOARD_SIZE - 1
    else BOARD_SIZE + 1
    end
  end
  
  def skip_square?(square_index, type)
    case type
    when :columns then false
    when :reverse_diagonal then beginning_squares?(square_index)
    else  ending_squares?(square_index)
    end
  end
  
  def get_line(square_index, type)
    line = []
    SQUARES_TO_WIN.times do
      line << squares.keys[square_index]
      square_index += next_square_index(type)
    end
    line.compact
  end

  def get_winning_line(type)
    squares.size.times do |square_index|
      next if skip_square?(square_index, type)
      line = get_line(square_index, type)
      return line if line.size == SQUARES_TO_WIN && all_same_marker?(line)
    end
    nil
  end

  def winning_line
    get_winning_line(:rows)      ||
    get_winning_line(:columns)   ||
    get_winning_line(:diagonals) ||
    get_winning_line(:reverse_diagonal)
  end

  def all_marked?(square_line)
    square_line.all?(&:marked?)
  end

  def all_same?(square_line)
    square_line.map(&:marker).uniq.one?
  end

  def all_same_marker?(line)
    square_line = squares.values_at(*line)
    all_marked?(square_line) && all_same?(square_line)
  end

  # visual helpers

  def row_delimiter
    delimiter = '-' * 5
    "#{delimiter}+" * (BOARD_SIZE - 1) + "#{delimiter}\n"
  end

  def square_delimiter(index)
    end_of_row?(index) ? "\n" : "|"
  end

  def format_square(square)
    square = square.marker
    square.uncolorize.size == 1 ? "  #{square}  " : "  #{square} "
  end

  def color_green(winning_line)
    winning_line.each do |key|
      self[key] = squares[key].marker.green
    end
  end

  # position finders

  def before_new_row?(index)
    end_of_row?(index) && index != (BOARD_SIZE * BOARD_SIZE)
  end

  def end_of_row?(index)
    (index % BOARD_SIZE).zero?
  end

  def beginning_of_row?(index)
    end_of_row?(index + (BOARD_SIZE - 1))
  end
  
  def ending_squares?(index)
    (SQUARES_TO_WIN - 1).times do
      return true if end_of_row?(index + 1)
      index += 1
    end
    false
  end
  
  def beginning_squares?(index)
    (SQUARES_TO_WIN - 1).times do
      return true if beginning_of_row?(index + 1)
      index -= 1
    end
    false
  end
  
end
