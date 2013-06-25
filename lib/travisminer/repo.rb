require 'set'

module TravisMiner

  class RepoExtractor < JSONExtractor
    def initialize(url)
      super(url)
      @slugs = Set.new
    end

    def importslugs(fname)
      isdata = false
      File.foreach(fname) do |line|
        line.strip!
        if (!isdata)
          isdata = true if (line =~ /^@data/)
          next
        end

        slug = line.split(",")[1]
        @slugs.add(slug)
      end
    end

    def getbuilds(slug)
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

      # First page
      builds = JSONExtractor.new("https://api.travis-ci.org/repositories/%s/builds.json" % slug).get
      raise abort "No builds could be retrieved for slug %s" % [slug] if (builds.nil? or builds.empty?)

      printBuildPage(slug, builds)

      # N additional pages
      while (builds.last["number"].to_i > 1)
        builds = JSONExtractor.new("https://api.travis-ci.org/repositories/%s/builds.json?after_number=%s" % [slug,builds.last["number"]]).get
        raise abort "No builds could be retrieved for slug %s" % [slug] if (builds.nil? or builds.empty?)

        printBuildPage(slug, builds)
      end
    end

    def printBuildPage(slug, builds)
      builds.each do |build|
        next if (build['state'] != "finished")
        print "%s" % slug
        build.keys.sort.each do |k|
          print ",%s" % [sanitize(build[k].to_s)] if (k != "slug")
        end
        puts
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
        print ",#{sanitize(repo[k])}"
      end

      puts
    end

    def sanitize(val)
      return val.to_s.gsub("\n", ":_:NEWLINE:_:").gsub(",", ":_:COMMA:_:").gsub("'", ":_:QUOTE:_:").gsub("\"", ":_:DQUOTE:_:").gsub("@", ":_:AT:_:")
    end

    # Poll on the travis-ci services to collect a list of slugs
    def getprojects()
      printRepoHeader
      
      loop do
        # Print each of the new returned repositories
        begin
          get.each do |repo|
            printRepo(repo) if (@slugs.add?(repo['slug']))

            # Flush to prevent data loss if we crash
            STDOUT.flush
          end
        rescue Exception => msg
          STDERR.puts "WARNING: Poll failed at #{Time.now}"
          STDERR.puts msg
        end

        # Poll every 5 minutes
        sleep 300
      end
    end
  end

end
