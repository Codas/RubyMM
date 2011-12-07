require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Scraper::ParadoxScraper do
  before do
    @game1 = "spec/remote_data/tehparadox/game1.html"
    @game2 = "spec/remote_data/tehparadox/game2.html"
    @game3 = "spec/remote_data/tehparadox/game3.html"
    @movie1 = "spec/remote_data/tehparadox/movie1.html"
    @movie2 = "spec/remote_data/tehparadox/movie2.html"
    @movie3 = "spec/remote_data/tehparadox/movie3.html"
    @show1 = "spec/remote_data/tehparadox/show1.html"
    @show2 = "spec/remote_data/tehparadox/show2.html"
    @show3 = "spec/remote_data/tehparadox/show3.html"
    @show4 = "spec/remote_data/tehparadox/show4.html"
    @show5 = "spec/remote_data/tehparadox/show5.html"
  end

  def paradox_infos(file)
    str = File.open(file, 'rb') { |f| f.read }
    scraper = Scraper::ParadoxScraper.new str
    scraper.scraped_data
  end

  context "Fetching Games" do
  it "correctly fetches Game 1" do
    infos = paradox_infos @game1

    infos[:resources].size.should == 4
    infos[:resources].each do |res|
      res.urls.size.should == 1
    end
  end

  it "correctly fetches Game 2" do
    infos = paradox_infos @game2

    infos[:resources].size.should == 13
    # crack
    infos[:resources][0].urls.size.should == 1
    infos[:resources][1].urls.size.should == 1
    infos[:resources][2].urls.size.should == 1
    # Fsnc / FJ / FSrv / MiX / MU / NL
    infos[:resources][3].urls.size.should == 16
    infos[:resources][4].urls.size.should == 16
    infos[:resources][5].urls.size.should == 16
    infos[:resources][7].urls.size.should == 8
    infos[:resources][8].urls.size.should == 16
    
    # in progress..
    [6, 9, 12].each do |n|
      infos[:resources][n].urls.size.should == 1
      infos[:resources][n].title.should =~ /in progress/i
    end

    # RS
    infos[:resources][10].urls.size.should == 1
    infos[:resources][10].title.should_not =~ /in progress/i
  end

  it "correctly fetches Game 3" do
    infos = paradox_infos(@game3)

    infos[:resources].size.should == 1
    infos[:resources][0].urls.size.should == 1
  end
  end

  context "Fetching Movies" do
    it "correctly fetches Movie 1" do
      infos = paradox_infos(@movie1)

      infos[:resources].size.should == 7
      6.times do |n|
        infos[:resources][n].urls.size.should == 6
      end
      infos[:imdb].should =~ /tt1446147/
    end

    it "correctly fetches Movie 2" do
      infos = paradox_infos(@movie2)

      infos[:resources].size.should == 4

      infos[:resources][0].urls.size.should == 20
      infos[:resources][1].urls.size.should == 20
      infos[:resources][2].urls.size.should == 1
      infos[:resources][3].urls.size.should == 1
    end

    it "correctly fetches Movie 3" do
      infos = paradox_infos(@movie3)

      infos[:resources].size.should == 6

      [0,1,2,3,5].each do |n|
        infos[:resources][n].urls.size.should == 6
      end
      infos[:resources][4].urls.size.should == 1
    end
  end

  context "fetching TVShows" do
    it "correctly fetches Show 1" do
      infos = paradox_infos(@show1)

      infos[:resources].size.should == 11

      (0..4).each do |n|
        infos[:resources][n].urls.size.should == 1
      end
      (5..10).each do |n|
        infos[:resources][n].urls.size.should == 3
      end
    end

    it "correctly fetches Show 2" do
      infos = paradox_infos(@show2)

      infos[:resources].size.should == 7

      (0..6).each do |n|
        infos[:resources][n].urls.size.should == 2
      end
    end

    it "correctly fetches Show 3" do
      infos = paradox_infos(@show3)

      infos[:resources].size.should == 10

      (0..4).each do |n|
        infos[:resources][n].urls.size.should == 1
      end
      (5..9).each do |n|
        infos[:resources][n].urls.size.should == 2
      end
    end

    it "correctly fetches Show 4" do
      infos = paradox_infos(@show4)

      infos[:resources].size.should == 6

      (0..5).each do |n|
        infos[:resources][n].urls.size.should == 1
      end
    end

    it "correctly fetches Show 5" do
      infos = paradox_infos(@show5)

      infos [:resources].size.should == 10

      (0..4).each do |n|
        infos[:resources][n].urls.size.should == 1
      end
      (5..9).each do |n|
        infos[:resources][n].urls.size.should == 3
      end
    end
  end
end
