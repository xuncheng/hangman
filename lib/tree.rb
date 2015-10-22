class Tree
  def initialize
    @tree = {}
    build_tree
  end

  def fetch(key, tree = nil)
    (tree || @tree)[key.to_s]
  end

  private

  def build_tree
    puts "构建决策树，可能需要花费1～2分钟...\n"

    filename = __dir__ + "/../data/tree.json"
    if !File.exist?(filename)
      words.each do |size, list|
        list.map! { |w| Word.new(w) }
        @tree[size] = compile(('A'..'Z').to_a, list)
      end
      File.open(filename) { |f| f << tree.to_json }
    end
    @tree = JSON.parse(File.read filename)
  end

  def words
    File.read(__dir__ + '/../data/words.txt').upcase.strip.split.group_by(&:size)
  end

  def compile(chars, words)
    if words.empty?
      return 0
    elsif chars.empty?
      return 1
    end

    c = chars.max_by do |c|
      words.count { |w| w.indices(c) }
    end

    chars -= [c]

    r = words.group_by { |word| word.indices(c) }

    return 0 if r.size == 1 and r.keys.first.nil?

    r.tap do |r|
      r.keys.each { |k| r[k] = compile(chars, r[k]) }
    end
  end
end
