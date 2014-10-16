module ModeWca
  module Local
    class Package < LocalFile
      def unpack
        puts "Unpacking #{filename}"
        Zip::ZipFile.open(path) do |zip_file|
          zip_file.each do |f|
            f_path=File.join(DIRECTORY, base, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          end
        end
      end
    end
  end
end
