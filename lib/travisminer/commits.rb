module TravisMiner

  class ChurnExtractor < GithubMiner

    def getcommits(slug, hdr=false, path=".travis.yml")
      if (hdr)
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
      end

      user, repo = slug.split("/")
      @github.repos.commits.list(user, repo, :path => path).each_page do |page|
        page.each do |commit|
          printcommit(slug, commit)
        end
      end
    end

    def sanitize(val)
      return val.to_s.gsub("\n", ":_:NEWLINE:_:").gsub(",", ":_:COMMA:_:").gsub("'", ":_:QUOTE:_:").gsub("\"", ":_:DQUOTE:_:").gsub("@", ":_:AT:_:")
    end

    def printcommit(slug, commit)
      mycommit = commit["commit"]

      # Slug
      print slug

      # Commit SHA
      print ",%s" % [commit["sha"]]

      # author and committer info
      printuser(mycommit["author"])
      printuser(mycommit["committer"])

      # commit message
      print ",'%s'" % sanitize(mycommit["message"])

      # Metadata SHAs
      print ",%s" % mycommit["tree"]["sha"]
      if (!commit["parents"].nil? and !commit["parents"].empty?)
        puts ",%s" % commit["parents"].first["sha"]
      else
        puts ",NULL"
      end

    end

    def printuser(user)
      print ",%s,%s,%s" % [user["name"],user["email"],user["date"]]
    end
  end
end
