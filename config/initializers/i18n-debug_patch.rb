if !ENV['I18N_DEBUG']
  puts 'i18n-debug is disabled by default. set env I18N_DEBUG=1 to enable it.'
end

module I18n
  module Debug
    module Hook
      alias_method :old_lookup, :lookup
      def lookup(*args)
        if ENV['I18N_DEBUG']
          old_lookup(*args)
        end
      end
    end
  end
end
