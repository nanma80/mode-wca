module ModeWca
  class Agent
    
    def start
      config
      downloader = Wca::Downloader.new
      p downloader.download
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
