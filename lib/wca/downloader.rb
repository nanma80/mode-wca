module ModeWca
  module Wca
    class Downloader
      DOMAIN = 'www.worldcubeassociation.org'
      EXPORT_PATH = '/results/misc/'
      EXPORT_PAGE = 'export.html'
      TSV_URL_PATTERN = /TSV: <a href='(WCA_export492_\d+.tsv.zip)'>/
      CACHE_DIRECTORY = 'cache/'

      def download
        puts "Download starting"
        Net::HTTP.start("www.worldcubeassociation.org") do |http|
          resp = http.get(EXPORT_PATH + tsv_url)
          open(CACHE_DIRECTORY + tsv_url, "wb") do |file|
              file.write(resp.body)
          end
        end
        puts "Download finished"
      end

      def tsv_url
        return @tsv_url_cache if @tsv_url_cache

        full_path = 'https://' + DOMAIN + EXPORT_PATH + EXPORT_PAGE
        page_content = RestClient.get(full_path)[0..3000] # avoid an invalid UTF-8 character

        if match = TSV_URL_PATTERN.match(page_content)
          @tsv_url_cache = match[1]
          return @tsv_url_cache
        end
        raise "TSV URL not found. \nPage URL:\n#{full_path}\nPage Content:\n#{page_content}"
      end
    end
  end
end
