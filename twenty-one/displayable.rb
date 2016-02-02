module Displayable
  def prompt(msg)
    puts "=> #{msg}"
  end

  def clear
    system('clear') || system('cls')
  end

  def clear_prior_and_post
    clear
    yield
    clear
  end

  def in_progress_indicator(msg)
    print msg.capitalize + ' '
    4.times do
      print '.'
      sleep 0.4
    end
    puts
  end
end
