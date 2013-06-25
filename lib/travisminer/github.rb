begin
  require 'github_api'
  require 'highline/import'
rescue LoadError
  abort $!
end

module TravisMiner
  class GithubMiner
    def initialize
      username = ask("Enter your username:  ") do |q|
        q.echo = true
      end
      pw = ask("Enter your password:  ") do |q|
        q.echo = "*"
      end
      
      @github = Github.new(:login => username, :password => pw)
      pw = nil
    end
  end
end
