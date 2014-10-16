module ModeWca
  module ModeClient
    class Uploader
      def upload(csv)
        upload = ::Mode::Sdk::Upload.new(csv.content)
        upload.create
        upload_token = upload.token

        table = ::Mode::Sdk::Table.new(csv.base)

        table.columns = csv.columns

        table.description = 'Loaded from WCA website'

        table.upload_token = upload_token

        table.create unless table.exists?
        table.replace
      end
    end
  end
end
