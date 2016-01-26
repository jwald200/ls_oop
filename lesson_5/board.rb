class Board
  BOARD_SIZE = 3
  SQUARES_TO_WIN = 3
  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def reset
    (1..BOARD_SIZE * BOARD_SIZE).each do |index|
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

  def rows
    squares.keys.each_slice(BOARD_SIZE).to_a
  end

  def columns
    rows.transpose
  end

  def diagonals
    diagonals = []
    counter   = 0
    while diagonals.size < BOARD_SIZE * 2
      diagonals << squares.keys[counter]

      if diagonals.size >= BOARD_SIZE
        counter -= (BOARD_SIZE - 1)
      else
        counter += BOARD_SIZE.next
      end
    end
    diagonals.each_slice(BOARD_SIZE).to_a
  end

  def lines
    rows +
    columns +
    diagonals
  end

  def winning_line
    lines.each do |line|
      win_line = find_winning_line(line)

      return win_line if win_line
    end
    nil
  end

  def find_winning_line(line)
    line.size.times do |index|
      win_line = line[index, SQUARES_TO_WIN]
      next if win_line.size < 3
      return win_line if all_squares_have_same_marker?(win_line)
    end
    nil
  end

  def all_marked?(square_line)
    square_line.all?(&:marked?)
  end

  def all_same?(square_line)
    square_line.map(&:marker).uniq.one?
  end

  def all_squares_have_same_marker?(line)
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
end
