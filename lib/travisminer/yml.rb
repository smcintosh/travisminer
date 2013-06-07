begin
  require 'github_api'
  require 'base64'
rescue LoadError
  abort $!
end

module TravisMiner

  class YMLExtractor
    def initialize
      @github = Github.new
    end

    def getyml(user, repo, path=".travis.yml")
      encoded = @github.repos.contents.get(user, repo, path)['content']
      Base64.decode64(encoded)
    end
  end

end
