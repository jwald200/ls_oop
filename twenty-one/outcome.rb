module Outcome
  def opponent(participant)
    self.participants.detect { |opponent| opponent != participant }
  end

  def detect_buster
    self.participants.detect(&:busted?)
  end

  def detect_winner
    self.participants.max_by(&:total)
  end

  def tie?
    self.participants.collect(&:total).uniq.one?
  end

  def display_outcome
    if tie?
      puts "It's a tie!"
      return
    end

    buster = detect_buster
    winner = detect_winner

    if buster
      puts "#{buster.name} busted! #{opponent(buster).name} wins!"
    else
      puts "#{winner.name} wins! #{opponent(winner).name} losses!"
    end
  end
end
