module Remote
  class Response
    attr_accessor :status, :header, :expected_length, :mime_type,
      :text_encoding, :url, :suggested_filename

    def initialize(args)
      args.each do |key, value|
        if respond_to? "#{key}="
          send "#{key}=".to_sym, value
        end
      end
    end

    def successfull?
      status == 200
    end

  end
end
