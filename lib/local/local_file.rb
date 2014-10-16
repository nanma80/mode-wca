module ModeWca
  module Local
    class LocalFile
      attr_reader :filename

      DIRECTORY = 'cache'

      def initialize(filename)
        @filename = filename
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
    end
  end
end

