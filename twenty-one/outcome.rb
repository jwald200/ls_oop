module Outcome
  def opponent(participant)
    participants.detect { |opponent| opponent != participant }
  end

  def detect_buster
    participants.detect(&:busted?)
  end

  def detect_winner
    participants.max_by(&:total)
  end

  def tie?
    participants.collect(&:total).uniq.one?
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
