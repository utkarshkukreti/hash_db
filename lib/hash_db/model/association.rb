module HashDB
  module Model
    module ClassMethods
      def has_many(name, args = {})
        klass = args[:class]
        foreign_key = args[:foreign_key]

        klass.keys foreign_key

        define_method "#{name}" do
          @attributes[name] ||= begin
            base_id = id
            [].tap do |array|
              array.define_singleton_method :<< do |object|
                object.send("#{foreign_key}=", base_id)
                super object
              end

              array.define_singleton_method :create do |*args|
                klass.create(*args).tap do |object|
                  array << object
                end
              end
            end
          end
        end
      end

      def belongs_to(name, args = {})
        klass = args[:class]
        key = args[:key]

        define_method "#{name}" do
          @attributes[name]
        end

        define_method "#{name}=" do |object|
          @attributes[name] = object
        end

        define_method "#{key}" do
          @attributes[name] && @attributes[name].id
        end

        define_method "#{key}=" do |id|
          @attributes[name] = klass.find_by(id: id)
        end
      end
    end
  end
end
