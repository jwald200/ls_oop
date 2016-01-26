class Square
  VALID_MARKERS = ['X'.blue, 'O'.yellow, 'L'.cyan, '$'.magenta]
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def unmarked?
    !marked?
  end

  def marked?
    VALID_MARKERS.map(&:uncolorize).include?(marker.uncolorize)
  end

  def to_s
    marker
  end
end
