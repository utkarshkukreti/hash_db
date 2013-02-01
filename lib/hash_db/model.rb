module HashDB
  module Model
    def self.included(klass)
      klass.extend ClassMethods
    end

    def initialize(args = {})
      @attributes = {}
      args.each do |key, value|
        if respond_to?("#{key}=")
          send("#{key}=", value)
        else
          raise InvalidKeyError.new "Invalid key #{key}."
        end
      end
    end

    module ClassMethods
      def keys(*keys)
        keys.each do |key|
          define_method "#{key}" do
            @attributes[key]
          end

          define_method "#{key}=" do |value|
            @attributes[key] = value
          end
        end
      end
    end
  end
end
