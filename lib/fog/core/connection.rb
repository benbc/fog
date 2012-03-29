module Fog
  class Connection

    def initialize(url, persistent=false, params={})
puts url
      @excon = Excon.new(url, params)
      @persistent = persistent
    end

    def request(params, &block)
puts params.inspect
      unless @persistent
        reset
      end
      unless block_given?
        if (parser = params.delete(:parser))
          body = Nokogiri::XML::SAX::PushParser.new(parser)
          params[:response_block] = lambda { |chunk, remaining, total| body << chunk }
        end
      end

      response = @excon.request(params, &block)
puts response.inspect

      if parser
        body.finish
        response.body = parser.response
      end

      response
    end

    def reset
      @excon.reset
    end

  end
end
