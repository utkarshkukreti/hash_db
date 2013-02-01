module HashDB
  module Model
    attr_accessor :id

    def self.included(klass)
      klass.extend ClassMethods
      klass.all = []
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

    def save
      if @id.nil?
        @id = if self.class.all.any?
                self.class.all.last.id + 1
              else
                1
              end
      end
      self.class.all[@id - 1] = self
    end

    module ClassMethods
      attr_accessor :all

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
