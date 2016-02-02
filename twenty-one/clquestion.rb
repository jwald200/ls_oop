class CLquestion
  private_class_method :new
  attr_accessor :question, :error_msg, :answer, :options, :string

  def initialize(question)
    @question = question
  end

  def self.ask(question)
    clquestion = new(question)
    yield(clquestion) if block_given?
    clquestion.ask
  end

  def ask
    puts question
    loop do
      self.answer = gets.chomp.downcase
      break if validated?
      puts error_msg
    end
    answer
  end

  private

  def validated?
    if options
      options.include?(answer)
    elsif string
      !answer.empty?
    else
      true
    end
  end
end
