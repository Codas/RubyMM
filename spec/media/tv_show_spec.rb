require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Media::TVShow do
  before do
    @episode_hash = {:season => 3, :episode => 8}
    @show_hash = {:name => "Great TV Show!"}
  end


  describe "creating new shows and episodes" do
    it "should create a new TV Show" do
      show = Media::TVShow.new @show_hash
      show.name.downcase.should == @show_hash[:name].downcase
    end

    it "should create a new episode" do
      h = { :season => 3, :episode => 8}
      ep = Media::Episode.new @episode_hash
      ep.season.should == @episode_hash[:season]
      ep.episode.should == @episode_hash[:episode]
    end

    it "should be possible to add Episodes to a TVShow" do
      show = Media::TVShow.new @show_hash
      ep = Media::Episode.new @episode_hash
      show << ep

      show.episodes.size.should == 1
      show.episodes.include?(ep).should be_true
      ep.tv_show.should == show
    end
  end

  context "Handling episode resources" do
    it "should allow to add valid resources" do
      ep = Media::Episode.new @episode_hash
      resource = {
        :tags => { 
          :resolution => "720p",
          :source => "web-dl"
        }, 
        :urls => [ "http://tehparadox.com/forum/printthread.php?t=3518613" ]
      }
      resource = Media::Resource.new resource

      ep.add_resource resource
      ep.resources.size.should == 1
      ep.resources.first.should == resource
    end

    it "should not add the same resource twice" do
      ep = Media::Episode.new @episode_hash
      resource1 = {
        :tags => {
          :resolution => "720p",
          :source => "web-dl"
        }, 
        :urls => [ "http://tehparadox.com/forum/printthread.php?t=3518613" ]
      }
      resource1 = Media::Resource.new resource1

      resource2 = {
        :tags => {
          :resolution => "something weird",
          :source => "VHS (yeah!)"
        }, 
        :urls => [ "http://tehparadox.com/forum/printthread.php?t=3518613" ]
      }
      resource2 = Media::Resource.new resource2

      ep.add_resource resource1
      ep.add_resource(resource2).should == nil
      ep.resources.size.should == 1
    end
  end
end
