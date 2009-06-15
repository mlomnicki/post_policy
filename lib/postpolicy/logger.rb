require 'syslog'

module Logger

  @@app_name = "rpolicy"
  @@log_opts = (Syslog::LOG_PID | Syslog::LOG_CONS)
  @@facility = Syslog::LOG_MAIL
  Syslog.open( @@app_name, @@log_opts, @@facility )

  def self.error( msg )
    Syslog.err( msg )
  end

  def self.info( msg )
    Syslog.info( msg )
  end

  def self.debug( msg )
    Syslog.debug( msg )
  end

  def self.warn( msg )
    Syslog.warning( msg )
  end


end

