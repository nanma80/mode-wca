module ModeWca
  module Local
    class CsvFile < LocalFile
      attr_accessor :columns

      def content
        File.open(path, 'r') { |f| f.read }
      end
    end
  end
end
