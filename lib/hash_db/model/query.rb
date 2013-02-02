module HashDB
  module Model
    module ClassMethods
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

      def find(value)
        find_by @primary_key => value
      end
      alias_method :[], :find
    end
  end
end
