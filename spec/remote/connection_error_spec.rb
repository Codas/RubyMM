require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Remote::ConnectionError do
  it "should give back all the data it was instanciated with" do
    error_hash = {
      :code => 666,
      :description => "too common",
      :reason => "no reason given",
      :help => "some usefull help",
      :url => "http://google.com"
    }

    error = Remote::ConnectionError.new error_hash
    error.code.should        == error_hash[:code]
    error.description.should == error_hash[:description]
    error.reason.should      == error_hash[:reason]
    error.help.should        == error_hash[:help]
    error.url.should         == error_hash[:url]
  end	

  it "should fail silently with invalid options" do
    error_hash = {
      :code => 666,
      :notvalid => "not a valid value"
    }

    error = Remote::ConnectionError.new error_hash
    error.code.should        == error_hash[:code]
    lambda{error.notvalid}.should raise_error
  end
end
