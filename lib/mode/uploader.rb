module ModeWca
  module ModeClient
    class Uploader
      def start(csv)
        puts "Uploading #{csv.path} to Mode"
        upload = mode_upload(csv)
        load_table(csv, upload.token)
      end

      def mode_upload(csv)
        mode_upload = Mode::Sdk::Upload.new(csv.content)
        mode_upload.create
        puts "Upload created for #{csv.path}"
        mode_upload
      end

      def load_table(csv, token)
        table_name = csv.base.downcase
        puts "Mode destination table: #{table_name}"
        table = Mode::Sdk::Table.new(table_name)
        table.columns = csv.columns
        table.description = "Loaded from the WCA website at #{Time.now.utc}"

        table.upload_token = token

        table.create unless table.exists?
        puts "Replacing table for #{table_name}"

        response = table.replace
        import_path = response.body['_links']['self'].fetch('href')
        import      = Mode::Sdk::TableImport.new(import_path)

        import.poll do |repr|
          puts self.class.poll_status(repr)
        end

        puts "Finished replacing table #{table_name}"
      end

      class << self
        # Construct status output for a given TableImport API response
        #
        # @param repr [Hash] the API representation of the TableImport
        #
        # @return [String] the status
        #
        def poll_status(repr)
          state  = repr.fetch('state')
          status = "=> Import #{state}"

          case state
          when 'enqueued', 'running'
            status << "...\n"
          when 'succeeded'
            table_url = repr['_embedded']['table']['_links']['web']['href']
            status << "\n=> Created #{table_url}"
          else
            status << "\n#{pp(repr, '')}"
          end

          status
        end
      end
    end
  end
end
