require "travisminer"

=begin
describe TravisMiner::RepoExtractor, "#extract" do
  it "prints values" do
    myextractor = TravisMiner::RepoExtractor.new("https://api.travis-ci.org/repos.json")
    myextractor.should_not be_nil
    myextractor.extract
  end
end
=end

describe TravisMiner::YMLExtractor, "#getyml" do
  it "prints values" do
    myextractor = TravisMiner::YMLExtractor.new
    myextractor.should_not be_nil
    puts myextractor.getyml("mortardata", "mortar")
  end
end
