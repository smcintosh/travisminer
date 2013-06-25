module TravisMiner

  class ChurnExtractor < GithubMiner

    def initialize(user, repo, path=".travis.yml")
      super
      @slug = slug
      #url = "https://api.github.com/repos/%s/commits?path=.travis.yml" % slug
    end

    def getcommits
      puts "@relation bar"
      puts
      puts "@attribute slug string"
      puts "@attribute sha string"
      puts "@attribute auth_name string"
      puts "@attribute auth_email string"
      puts "@attribute auth_date string"
      puts "@attribute cmt_name string"
      puts "@attribute cmt_email string"
      puts "@attribute cmt_date string"
      puts "@attribute message string"
      puts "@attribute tree_sha string"
      puts "@attribute parent_sha string"
      puts
      puts "@data"

      @github.repos.commits.list(user, repo, path).each do |commit|
        printcommit(commit)
      end
    end

    def printcommit(commit)
      mycommit = commit["commit"]

      # Slug
      print slug

      # Commit SHA
      print ",%s" % [commit["sha"]]

      # author and committer info
      printuser(mycommit["author"])
      printuser(mycommit["committer"])

      # commit message
      print ",'%s'" % mycommit["message"]

      # Metadata shas
      print ",%s" % mycommit["tree"]["sha"]
      puts ",%s" % commit["parents"].first["sha"]
    end

    def printuser(user)
      puts "%s,%s,%s" % [user["name"],user["email"],user["date"]]
    end
  end
end
