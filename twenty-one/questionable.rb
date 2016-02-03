module Questionable
  def ask(question, answer = {})
    puts question

    loop do
      input = gets.chomp.downcase
      break(input) if validated?(input, answer)
      puts answer[:error_msg]
    end
  end

  def validated?(input, answer)
    if answer[:options]
      answer[:options].include?(input)
    elsif answer[:string]
      !input.empty?
    else
      true
    end
  end
end
