require "travisminer"

describe TravisMiner::RepoExtractor, "#extract" do
  it "prints values" do
    myextractor = TravisMiner::RepoExtractor.new("https://api.travis-ci.org/repos.json")
    myextractor.should_not be_nil
    myextractor.extract
  end
end
