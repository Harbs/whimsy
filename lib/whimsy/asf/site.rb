require_relative '../asf'
require 'nokogiri'

module ASF

  class Site
    @@list = {}

    def self.list
      templates = ASF::SVN['asf/infrastructure/site/trunk/content']
      file = "#{templates}/index.html"
      return @@list if not @@list.empty? and File.mtime(file) == @@mtime
      @@mtime = File.mtime(file)

      Committee.load_committee_info
      doc = Nokogiri::HTML.parse(File.read(file))
      list = doc.at("#by_name")
      if list
        list.search('a').each do |a|
          @@list[Committee.find(a.text).name] = 
            {link: a['href'], text: a['title']}
        end
      end

      list = doc.at("#by_category")
      if list
        list.search('a').each do |a|
          if a['title']
            @@list[Committee.find(a.text).name] = 
              {link: a['href'], text: a['title']}
          end
        end
      end

      @@list
    end

    def self.find(committee)
      committee = committee.name if ASF::Committee == committee
      list[committee]
    end
  end


  class Committee
    def site
      site = ASF::Site.find(name)
      site[:link] if site
    end

    def description
      site = ASF::Site.find(name)
      site[:text] if site
    end
  end
end
