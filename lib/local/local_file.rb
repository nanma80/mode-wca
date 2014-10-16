module ModeWca
  module Local
    class LocalFile
      attr_reader :filename

      DIRECTORY = 'cache'

      def initialize(filename)
        @filename = filename
        FileUtils.mkdir_p(File.dirname(path))
      end

      def path
        File.join(DIRECTORY, filename)
      end

      def exists?
        File.exists?(path)
      end

      def base
        filename.split('.')[0]
      end

      class << self
        def clear!
          FileUtils.rm_rf(Dir.glob(DIRECTORY + '/*'))
        end
      end
    end
  end
end

