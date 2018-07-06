require "lp/serializable/version"
require "lp/serializable/strategies"

module Lp
  module Serializable
    include Strategies

    class UnserializableCollection < StandardError
      def initialize(msg='Expected an object, but a collection was given.')
        super
      end
    end

    def serialize_and_flatten(resource, options={})
      base_hash = serialize_hash(resource)
      flatten_and_nest_data(base_hash, set_nested_option(options))
    end

    def serialize_and_flatten_with_class_name(resource, class_name, options={})
      raise UnserializableCollection if resource.is_a?(Array) 
      base_hash = serializable_hash_with_class_name(resource, 
        class_name, options)
      flatten_and_nest_data(base_hash, set_nested_option(options))
    end

    def serialize_and_flatten_collection(resource, class_name, options={})
      base_hash = serializable_hash_with_class_name(resource, 
        class_name, options)
      flatten_array_and_nest_data(base_hash, set_nested_option(options))
    end
  end
end