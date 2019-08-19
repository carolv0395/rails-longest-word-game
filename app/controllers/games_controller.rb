require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @letters
  end

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_serialized = open(url).read
    dictionary = JSON.parse(dictionary_serialized)
    dictionary['found']
  end

  def grid?(word, grid)
    letters = word.upcase.chars
    letters.all? { |letter| grid.include?(letter) } && letters.all? { |letter| letters.count(letter) <= grid.count(letter) }
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @result = {}
    if grid?(@word, @letters) && english?(@word)
      @result = { message: "Congratulations! #{@word} is a valid english word" }
    elsif grid?(@word, @letters)
      @result = { message: "Sorry but #{@word} does not seem to be a valid english word..." }
    else
      @result = { message: "Sorry but #{@word} can't be built out of grid." }
    end
    @result
  end
end
