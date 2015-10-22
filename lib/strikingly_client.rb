require 'httparty'

class StrikinglyClient
  attr_reader :current_response, :session_id, :number_of_words_to_guess, :number_of_guess_allowed_for_each_word

  def initialize(player_id)
    @current_response = request(playerId: player_id, action: "startGame")
    @session_id = @current_response["sessionId"]
    @number_of_words_to_guess = data["numberOfWordsToGuess"]
    @number_of_guess_allowed_for_each_word = data["numberOfGuessAllowedForEachWord"]
  end

  def give_me_a_word
    @current_response = request(sessionId: @session_id, action: "nextWord")
  end

  def make_a_guess(char)
    @current_response = request(sessionId: @session_id, action: "guessWord", guess: char)
  end

  def get_result
    @current_response = request(sessionId: @session_id, action: "getResult")
  end

  def submit_result
    @current_response = request(sessionId: @session_id, action: "submitResult")
  end

  def remaining_guess_count
    @number_of_guess_allowed_for_each_word - wrong_guess_count
  end

  def current_word; data["word"] end
  def wrong_guess_count; data["wrongGuessCountOfCurrentWord"] end

  def data
    return {} if @current_response.nil? || @current_response["data"].nil?

    @current_response["data"]
  end

  def request(data)
    HTTParty.post(ENV['REQUEST_URL'], {
      headers: {"Content-Type" => "application/json"},
      body: data.to_json
    })
  end
end
