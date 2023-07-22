require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = create_grid
  end

  def score
    attempt = params[:word]
    @grid = params[:hidden_grid]
    @in_grid = word_in_grid?(attempt, @grid)
    @fetch = fetch_word(attempt)
  end

  def create_grid
    grid = []
    10.times do
      grid << ('A'..'Z').to_a.sample
    end
    grid
  end

  def fetch_word(attempt)
    URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}") do |stream|
      return JSON.parse(stream.read)['found']
    end
  end

  def word_in_grid?(attempt, grid)
    # check if the words given are in the grid
    val = true
    attempt.chars.each do |word|
      unless grid.include? word.upcase
        val = false
        break
      end
    end
    return val
  end
end
