module PostPolicy

  # rule do 
  #   sender { format.value "michal.lomnicki@gmail.com" }
  #   recipient { format.regex /lomnicki.com.pl$/ }
  #   action "REJECT"
  # end
  #
  class Rule
    class Format

      class << self

        def format
          self
        end

        def value( val )
          DataSource::Value.new( val )
        end

        def regex( val )
          DataSource::Regex.new( val )
        end

        def file( val )
          DataSource::File.new( val )
        end

        def sql( val )
          DataSource::Sql.new( val )
        end

      end

    end

    def initialize( &block )
      instance_eval &block
    end

    def self.rule( &block )
      AccessManager << new( &block ).to_access
    end

    def sender( &block )
      @sender = Format.class_eval &block
    end

    def recipient( &block )
      @recipient = Format.class_eval &block 
    end

    def action( value )
      @action = value
    end

    def to_access
      Access.new( [@sender, @recipient].compact, @action )
    end

  end


end


