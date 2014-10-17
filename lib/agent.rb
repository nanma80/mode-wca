module ModeWca
  class Agent
    
    def start
      puts "[#{Time.now.utc}] Agent starting"
      config
      downloader = Wca::Downloader.new
      uploader = ModeClient::Uploader.new

      package = downloader.download
      tsv_files = package.unpack

      tsv_files.each do |tsv|
        uploader.start(tsv.to_csv)
      end
      puts "[#{Time.now.utc}] Agent exists"
    end

    def config
      mode_config = YAML.load_file(mode_config_path)['mode']
      
      Mode::Sdk.configure do |config|
        config.token  = mode_config['token']
        config.secret = mode_config['secret']
      end
    end

    def mode_config_path
      File.join(File.dirname(__FILE__), '../config', 'mode.yml')
    end
  end
end
