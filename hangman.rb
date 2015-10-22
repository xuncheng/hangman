require 'active_support/core_ext/module/delegation.rb'
require File.expand_path('../lib/tree.rb', __FILE__)
require File.expand_path('../lib/word.rb', __FILE__)
require File.expand_path('../lib/strikingly_client.rb', __FILE__)

class Hangman
  attr_reader :strikingly_client, :tree

  def initialize
    @tree = Tree.new
    @strikingly_client = StrikinglyClient.new(ENV['PLAYER_ID'])
  end

  %i(
    session_id
    number_of_words_to_guess
    number_of_guess_allowed_for_each_word
    give_me_a_word
    make_a_guess
    remaining_guess_count
    current_word
    get_result
    submit_result
  ).each { |method| delegate method, to: :strikingly_client }

  def start
    puts "\n"
    puts "#" * 80
    str = "开始猜#{number_of_words_to_guess}个单词"; puts "#{' ' * ((80-str.bytesize) / 2).round(0)}#{str}"
    puts "#" * 80

    1.upto(number_of_words_to_guess) do |i|
      init_guess
      puts "-" * 80
      puts "猜测第#{i}个单词，长度为#{current_word.size}，可以猜错#{number_of_guess_allowed_for_each_word}次。"

      guess_word
      puts "[依次猜过的字母]  #{@guessed_letters.inspect}，共#{@guessed_letters.count}个"
      puts "[结果]            #{success? ? '成功' : '失败'} | #{current_word}！"
      puts
    end

    submit_result?
  end

  def guess_word
    while (!success? && !remaining_guess_count.zero?) do
      break if @current_tree.nil? # 猜测的单词不在字典里，略过，直接猜测下一个单词
      make_a_guess(find_a_letter)
      puts "猜测的字母：#{@current_letter}，结果: [#{current_word}]，还可以猜错#{remaining_guess_count}次。"
      update_tree unless success?
    end
  end

  def submit_result?
    puts "猜单词结果是: #{get_result.parsed_response}\n\n"
    print "提交猜词结果 [Y/n]? "
    puts "提交成功: #{submit_result.parsed_response}" if gets.chomp.upcase[0] == 'Y'
  end

  def init_guess
    give_me_a_word
    @guessed_letters = []
    @current_tree = tree.fetch(current_word.size.to_s)
  end

  def find_a_letter
    @current_letter = @current_tree.find { |k, _| k.size > 0 }.first[0].tap do |letter|
      @guessed_letters << letter
    end
  end

  def update_tree
    matched_indexes = current_word.chars.map.with_index { |c, i| i if c == @current_letter }.compact!
    @current_tree = tree.fetch(matched_indexes.empty? ? "" : "#{@current_letter}#{matched_indexes.join(',')}", @current_tree)
  end

  def success?
    current_word && current_word.count("*").zero?
  end
end

hangman = Hangman.new
hangman.start
