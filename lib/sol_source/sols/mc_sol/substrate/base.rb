module Substrate 
  class Base
    def initialize
      @bins = structure
    end
    
    def [](bin)
      @bins[bin]
    end

    def []=(bin,value)
      @bins[bin] = value
    end

    def method_missing(method,*args)
      if method.to_s =~ /(.*)=$/
        return @bins[$1.intern] = args[0]
      else
        return @bins[method] if @bins.has_key?(method)
      end
      super
    end
    
    def structure 
      { :inhale_log => [],
        :exhale_log => [],
        :pending_namasca => {}
      }
    end
  end
end
