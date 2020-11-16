require "lp/serializable/strategies"
require "lp/serializable/exceptions"

module Lp
  module Serializable
    include Strategies
    include Exceptions

    def serialize_and_flatten(resource, options = {})
      return { :data => nil }  if resource.nil? # Match the return of serializable_class when given nil
      collection_option = collection?(false)
      base_hash = serialize_hash(resource, options.merge(collection_option))
      flatten_and_nest_data(base_hash, set_nested_option(options))
    end

    def serialize_and_flatten_with_class_name(
      resource,
      class_name,
      options = {}
    )
      raise UnserializableCollection if resource.is_a?(Array)
      collection_option = collection?(false)
      base_hash = serializable_hash_with_class_name(
        resource,
        class_name,
        options.merge(collection_option),
      )
      flatten_and_nest_data(base_hash, set_nested_option(options))
    end

    def serialize_and_flatten_collection(resource, class_name, options = {})
      collection_option = collection?(true)
      base_hash = serializable_hash_with_class_name(
        resource,
        class_name,
        options.merge(collection_option),
      )
      flatten_array_and_nest_data(base_hash, set_nested_option(options))
    end

    alias_method :serializable, :serialize_and_flatten
    alias_method :serializable_class, :serialize_and_flatten_with_class_name
    alias_method :serializable_collection, :serialize_and_flatten_collection
  end
end
