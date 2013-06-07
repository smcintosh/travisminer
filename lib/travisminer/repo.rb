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
  end

end
