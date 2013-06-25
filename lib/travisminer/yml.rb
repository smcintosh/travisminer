require 'base64'

module TravisMiner

  class YMLExtractor < GithubMiner
    def getyml(user, repo, path=".travis.yml")
      encoded = @github.repos.contents.get(user, repo, path)['content']
      Base64.decode64(encoded)
    end
  end

end
