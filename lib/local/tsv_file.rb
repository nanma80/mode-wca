module ModeWca
  module Local
    class TsvFile < LocalFile
      def columns
        return @columns_cache if @columns_cache

        puts "Extracting columns from #{path}"

        column_names = []
        column_types = []
        first_row = true

        File.open(path).each do |line|
          row = line.chomp.split("\t")
          if first_row
            row.each do |cell|
              column_names << ModeWca::Helper.camel_to_snake(cell)
            end
            first_row = false
          else
            update_column_types(column_types, row)
          end
        end

        @columns_cache = pivot(column_names, column_types)
      end

      def to_csv(csv_filename = nil)
        if csv_filename.nil?
          csv_filename = base + '.csv'
        end

        output = CsvFile.new(csv_filename)

        puts "Converting TSV #{path} to CSV #{output.path}"
        first_row = true

        line_counter = 0
        CSV.open(output.path, "wb") do |csv|
          File.open(path).each do |line|
            if first_row
              first_row = false
            else
              fields = line.chomp.split("\t")
              csv << fields
              line_counter += 1
            end
          end
        end

        puts "Number of lines in #{output.path}: #{line_counter}"
        puts "Size of #{output.path}: #{output.size}"
        output.columns = columns
        output
      end

      private
      
      def update_column_types(column_types, row)
        row.each_with_index do |cell, index|
          unless column_types[index] == 'string'
            if cell =~ /^[0-9]+$/
              type = 'integer'
            else
              type = 'string'
            end
            column_types[index] = type
          end
        end
      end

      def pivot(names, types)
        result = []
        names.each_with_index do |name, index|
          result << {name: name, type: types[index]}
        end
        result
      end
    end
  end
end
