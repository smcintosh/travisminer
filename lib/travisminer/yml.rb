begin
  require 'github_api'
  require 'base64'
  require 'highline/import'
rescue LoadError
  abort $!
end

module TravisMiner

  class YMLExtractor
    def initialize
      username = ask("Enter your username:  ") do |q|
        q.echo = true
      end
      pw = ask("Enter your password:  ") do |q|
        q.echo = "*"
      end

      
      @github = Github.new(:login => username, :password => pw)
    end

    def getyml(user, repo, path=".travis.yml")
      encoded = @github.repos.contents.get(user, repo, path)['content']
      Base64.decode64(encoded)
    end
  end

end
