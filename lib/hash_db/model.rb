module HashDB
  module Model
    attr_accessor :id, :attributes

    def self.included(klass)
      klass.extend ClassMethods
      klass.all = {}
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
                self.class.all.keys.last + 1
              else
                1
              end
      end
      self.class.all[@id] = self
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

      def where(*args)
        # Doesn't really take all cases into account.
        # Good enough for now. :)
        if args.size == 1 && Hash === args.first
          args = args.first.map do |key, value|
            [key, :==, value]
          end
        elsif !(Array === args.first)
          args = [args]
        end

        @all.values.select do |object|
          args.all? do |key, method, value|
            # TODO: Should access through the getter?
            object.attributes[key].send(method, value)
          end
        end
      end

      def find_by(*args)
        # Not efficient, and I know it.
        where(*args).first
      end
    end
  end
end
