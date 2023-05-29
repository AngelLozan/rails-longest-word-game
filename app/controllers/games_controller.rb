require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
    session[:letters] = @letters
  end

  def score
    if !session[:score]
      @score = 0
    else
      @score = session[:score]
    end
    # raise
    @letters = session[:letters]
    # @letters = params[:grid] # @dev If using the hidden field tag in new view to pass params
    @message = run_game(params[:word], @letters)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    charset = Array("a".."z")
    g = Array.new(grid_size) { charset.sample }.join
    return g.chars.map(&:upcase) # @dev returns array
  end

  def run_game(attempt, grid)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    serialized = URI.open(url).read
    res = JSON.parse(serialized)

    message = ""

    legit = res["found"] # @dev True or false

    attempt_arr = attempt.upcase.chars
    compare_arr = []

    attempt_arr.each { |char| compare_arr << grid.slice!(grid.index(char)) if grid.include?(char) }

    on_grid = attempt_arr == compare_arr

    if legit && on_grid
      message = "Congratulations! #{attempt} is a valid English word!"
      @score += 10
      session[:score] = @score
    elsif !on_grid
      message = "Sorry, #{attempt.split("").to_s} is not in the original grid"
    else
      message = "Sorry, #{attempt} does not appear to be an english word..."
    end

    return Hash.try_convert({ message: message })
  end
end
