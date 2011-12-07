require "lib/rmm/media"
require "lib/rmm/remote"
require "lib/rmm/scraper"

framework 'cocoa'

def download_complete_dep
  Proc.new do |connection, data|
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
end

def download_error
  Proc.new do |connection, error|
    puts error
  end
end

def download_complete
  Proc.new do |connection, data|
    $queue.sync do
      s = Scraper::ParadoxScraper.new data
      res = s.scraped_data
      puts res[:name]
      puts "Found #{res[:ressources].size} Download Links"
      fs = res[:ressources].map do |r|
        r.urls.map{|u| u =~ /filesonic\.com/}
      end.flatten.inject { |a, b| a or b }
      puts "Filesonic? #{(fs)? 'YES!':'No :('}"
      puts

      $still_to_be_done -= 1
      all_done if $still_to_be_done == 0
    end
  end
end

def all_done
  puts "##############################"
  puts
  puts "all done!"
  puts "Total time elapsed: #{Time.now - $first}"
  puts "Time to scrape all #{$total} threads: #{Time.now - $second}"
  puts "that makes #{$total/(Time.now - $second)} tps! (Threads per second)"
end

def applicationDidFinishLaunching(notification)
  $queue = Dispatch::Queue.new('org.macruby.examples.gcd')

  url = "http://tehparadox.com/forum/printthread.php?t=1439182"
  callbacks = {
    :completed => download_complete,
    :error => download_error
  }

  $first = Time.now
  $total = 0

  puts "connecting..."

  Remote::Connection.new url, {:error => download_error} do |connection, data|
    scraper = Scraper::CardmanThread.new data
    movies = scraper.movies
    shows = scraper.tv_shows
    episodes = shows.map { |show| show.episodes }.flatten
    games = scraper.games
    puts "Found #{movies.size} Movies"
    puts "Found #{games.size} Games"
    puts "Found #{shows.size} TVShows"
    puts "Found #{episodes.size} Episodes"

    puts
    puts "fetching first 4 of every categorie"
    puts
    
    require "pp"

    list = movies[0..3].map {|e|e.ressources.map {|x| x.urls }}
    list << episodes[0..3].map {|e|e.ressources.map {|x| x.urls }}
    list << games[0..3].map {|e|e.ressources.map {|x| x.urls }}
    list = list.flatten
    $still_to_be_done = list.size
    $total = list.size

    puts "that makes #{$total} URIs total"
    puts
    puts "### here they come ###"
    puts

    $second = Time.now

    list.each do |url|
      Remote::Connection.new url, callbacks
    end
  end
end

NSApplication.sharedApplication.delegate = self
NSApplication.sharedApplication.run
