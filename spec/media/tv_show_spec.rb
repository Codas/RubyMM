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

	context "Handling episode ressources" do
		it "should allow to add valid ressources" do
			ep = Media::Episode.new @episode_hash
			ressource = {
				:resolution => "720p",
				:source => "web-dl",
				:url => "http://tehparadox.com/forum/printthread.php?t=3518613"
			}
			ep.add_ressource ressource
			ep.ressources.size.should == 1
			ep.ressources.first.should == ressource
		end

		it "should not add the same resource twice" do
			ep = Media::Episode.new @episode_hash
			ressource1 = {
				:resolution => "720p",
				:source => "web-dl",
				:url => "http://tehparadox.com/forum/printthread.php?t=3518613"
			}
			ressource2 = {
				:resolution => "something weird",
				:source => "VHS (yeah!)",
				:url => "http://tehparadox.com/forum/printthread.php?t=3518613"
			}
			ep.add_ressource ressource1
			ep.add_ressource(ressource2).should == nil
			ep.ressources.size.should == 1
		end
	end
end
