module Lp
  module Serializable
    module Exceptions
      class UnserializableCollection < StandardError
        def initialize(msg = "Expected an object, but a collection was given.")
          super
        end
      end
    end
  end
end
