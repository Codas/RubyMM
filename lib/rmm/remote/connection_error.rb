module Remote
  class ConnectionError
    attr_accessor :code, :description, :reason, :help, :url

    def initialize(args)
      args.each do |key, value|
        if respond_to? "#{key}="
          send "#{key}=".to_sym, value
        end
      end
    end
  end
end
