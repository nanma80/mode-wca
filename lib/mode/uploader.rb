module ModeWca
  module ModeClient
    class Uploader
      def upload(csv)
        puts "Uploading #{csv.path} to Mode"
        upload = ::Mode::Sdk::Upload.new(csv.content)
        upload.create
        upload_token = upload.token
        puts "Upload created for #{csv.path}"

        table = ::Mode::Sdk::Table.new(csv.base.downcase)

        table.columns = csv.columns

        table.description = 'Loaded from WCA website'

        table.upload_token = upload_token


        table.create unless table.exists?
        puts "Replacing table for #{csv.path}"

        table.replace
        puts "Finished uploading #{csv.path}"
      end
    end
  end
end
