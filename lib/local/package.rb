module ModeWca
  module Local
    class Package < LocalFile
      def unpack
        puts "Unpacking #{filename}"
        tsv_files = []

        Zip::ZipFile.open(path) do |zip_file|
          zip_file.each do |f|
            f_path = File.join(DIRECTORY, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            if File.exist?(f_path)
              File.delete(f_path)
            end
            zip_file.extract(f, f_path)
            tsv_files << TsvFile.new(f.name) if f.name.include?('.tsv')
          end
        end
        tsv_files
      end
    end
  end
end
