module PostPolicy
  module DataSource

    class File < Base

      def initialize( filename )
        @values = []
        ::File.open(filename).each_line { |line| @values << line.chomp }
      end

    end

  end
end
