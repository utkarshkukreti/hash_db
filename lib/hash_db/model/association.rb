module HashDB
  module Model
    module ClassMethods
      def has_many(name, args = {})
        klass = args[:class]
        foreign_key = args[:foreign_key]

        klass.keys foreign_key

        define_method "#{name}" do
          id = @id
          @attributes[name] ||= begin
            [].tap do |array|
              array.define_singleton_method :<< do |object|
                object.send("#{foreign_key}=", id)
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
    end
  end
end
