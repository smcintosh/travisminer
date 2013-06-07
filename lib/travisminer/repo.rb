require 'set'

module TravisMiner

  class RepoExtractor < JSONExtractor
    def extract
      puts "@relation travis_ci_data"
      puts
      puts "@attribute slug string"
      puts "@attribute branch string"
      puts "@attribute commit string"
      puts "@attribute duration numeric"
      puts "@attribute event_type string"
      puts "@attribute finished_at string"
      puts "@attribute id numeric"
      puts "@attribute message string"
      puts "@attribute number numeric"
      puts "@attribute repository_id numeric"
      puts "@attribute result numeric"
      puts "@attribute started_at string"
      puts "@attribute state string"
      puts
      puts "@data"

      json = get
      json.each do |repo|
        slug = repo['slug']
        repo['last_build_number'].to_i.times do |i|
          bid = i+1
          build = JSONExtractor.new("https://api.travis-ci.org/repositories/%s/builds.json?number=%s" % [slug,bid]).get
          if (build.size == 1)
            next if (build[0]['state'] != "finished")
            print "%s" % slug
            build[0].keys.sort.each do |k|
              print ",%s" % [build[0][k].to_s.gsub(/\n/, ":_:NEWLINE:_:")]
            end
            puts
          else
            raise "Incorrect cardinality %d of returned JSON object for build id %d" % [build.size, bid]
          end
        end
      end
    end

    def printRepoHeader
      puts "@relation travis_repos"
      puts
      puts "@attribute id numeric"
      puts "@attribute slug string"
      puts "@attribute description string"
      puts "@attribute last_build_id numeric"
      puts "@attribute last_build_number numeric"
      puts "@attribute last_build_status numeric"
      puts "@attribute last_build_result numeric"
      puts "@attribute last_build_duration numeric"
      puts "@attribute last_build_language string"
      puts "@attribute last_build_started_at string"
      puts "@attribute last_build_finished_at string"
      puts
      puts "@data"
    end

    def printRepo(repo)
      # Skip ID so that we can do a simple loop
      keys = ["slug", "description", "last_build_id", "last_build_number",
          "last_build_status", "last_build_result", "last_build_duration",
          "last_build_language", "last_build_started_at",
          "last_build_finished_at"]

      # Print ID
      print repo["id"]

      # Print all other keys, sanitizing newlines
      keys.each do |k|
        print ",#{repo[k].to_s.gsub("\n", ":_:NEWLINE:_:").gsub(",", ":_:COMMA:_:")}"
      end

      puts
    end

    # Poll on the travis-ci services to collect a list of slugs
    def getprojects(mins=1)
      slugs = Set.new
      tot_sleep = 0

      printRepoHeader
      
      begin
        # Print each of the new returned repositories
        get.each do |repo|
          printRepo(repo) if (slugs.add?(repo['slug']))
        end

        sleep 60
        tot_sleep += 1

      end while (tot_sleep < mins)

    end
  end

end
