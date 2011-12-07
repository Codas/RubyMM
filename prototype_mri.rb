require_relative "lib/rmm/media"
require_relative "lib/rmm/scraper"
require 'uri'
require 'net/http'

def download_complete(data)
  scraper = Scraper::CardmanThread.new data

  puts "### MOVIES ###"
  scraper.movies.each do |movie|
    puts "  #{movie.name}"
  end
  puts

  puts "### TV SHOWS ###"
  scraper.tv_shows.each do |show|
    puts "  #{show.name}"
    show.episodes.each do |episode|
      puts "    Episode #{episode.season} Season #{episode.episode}"
    end
  end
  puts

  puts "### GAMES ###"
  scraper.games.each do |game|
    puts "  #{game.name}"
  end
end

uri = URI "http://tehparadox.com/forum/printthread.php?t=1439182"

puts "connecting..."

data = Net::HTTP.get uri

download_complete(data)
