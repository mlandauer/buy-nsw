if !ENV['I18N_DEBUG']
  puts 'i18n-debug is disabled by default. set env I18N_DEBUG=1 to enable it.'
end

module I18n
  module Debug
    @on_lookup = lambda do |k, r|
      if ENV['I18N_DEBUG']
        logger.debug("[i18n-debug] #{k} => #{r.inspect}")
      end
    end
  end
end
