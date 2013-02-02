module HashDB
  module Model
    attr_accessor :attributes

    def self.included(klass)
      klass.extend ClassMethods
      klass.all = {}
      klass.keys :id
      klass.primary_key :id
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
      if id.nil?
        self.id = if self.class.all.any?
                self.class.all.keys.last + 1
              else
                1
              end
      end
      self.class.all[id] = self
    end

    def destroy
      self.class.all.delete id
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

      def create(args = {})
        new(args).tap do |object|
          object.save
        end
      end

      def primary_key(key = nil)
        if key
          @primary_key = key
        else
          @primary_key
        end
      end
    end
  end
end
