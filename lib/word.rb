class Word
  attr_reader :chars

  def initialize(word)
    @chars = {}
    init_chars(word)
  end

  def indices(c)
    chars[c]
  end

  private

  def init_chars(word)
    word.chars.each_with_index do |c, i|
      if @chars[c]
        @chars[c] << ",#{i}"
      else
        @chars[c] = "#{c}#{i}"
      end
    end
  end
end
