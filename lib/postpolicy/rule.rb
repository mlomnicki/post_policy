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
      @rule_sender = ACL::Sender.new( Format.class_eval( &block ) )
    end

    def recipient( &block )
      @rule_recipient = ACL::Recipient.new( Format.class_eval( &block ) )
    end

    def action( value )
      @rule_action = value
    end

    def to_access
      Access.new( [@rule_sender, @rule_recipient].compact, @rule_action )
    end

  end


end


