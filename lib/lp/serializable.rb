require "lp/serializable/exceptions"
require "lp/serializable/normalizer"

module Lp
  module Serializable
    include Exceptions

    def serialize(resource, serializer_options: {}, serializer_class: nil, eager_load: true)
      serializer = serializer_class || lookup_serializer(resource)
      modified_options = eager_load ? enable_eager_loading(serializer_options, serializer) : serializer_options
      json_api_hash = serializer.new(resource, modified_options).serializable_hash
      normalize_serialized_hash(json_api_hash)
    end

    def normalize_serialized_hash(hash)
      return hash unless hash
      Normalizer.new(hash).normalize
    end

    def lookup_serializer(resource, class_name: nil)
      resource_class = get_resource_class(resource)
      "#{resource_class}Serializer".constantize
    end

    # Legacy methods
   
    def serialize_and_flatten(resource, options = {})
      modified_options = options.merge({ is_collection: false })
      normalized_hash = serialize(resource, serializer_options: modified_options)
      apply_nested_option(normalized_hash, options)
    end

    def serialize_and_flatten_with_class_name(
      resource,
      class_name,
      options = {}
    )
      raise UnserializableCollection if resource.is_a?(Array)
      modified_options = options.merge({ is_collection: false })
      serializer = __legacy_lookup_serializer(resource, class_name)
      normalized_hash = serialize(resource, serializer_options: modified_options, serializer_class: serializer)
      apply_nested_option(normalized_hash, options)
    end

    def serialize_and_flatten_collection(resource, class_name, options = {})
      modified_options = options.merge({ is_collection: true })
      serializer = __legacy_lookup_serializer(resource, class_name)
      normalized_hash = serialize(resource, serializer_options: modified_options, serializer_class: serializer)
      apply_nested_option(normalized_hash, options)
    end

    def apply_nested_option(normalized_hash, options)
      is_nested = options.fetch(:nested, false)
      is_nested ? normalized_hash : { data: normalized_hash }
    end

    alias_method :serializable, :serialize_and_flatten
    alias_method :serializable_class, :serialize_and_flatten_with_class_name
    alias_method :serializable_collection, :serialize_and_flatten_collection

    private

    def enable_eager_loading(serializer_options, serializer)
      all_relationship_names = serializer.relationships_to_serialize.try(:keys)
      serializer_options.merge({ include: all_relationship_names })
    end

    def get_resource_class(resource)
      resource.try(:model) || resource.class
    end

    # Legacy lookup allows "class name" specification - deprecated in favor of passing class constant
    def __legacy_lookup_serializer(resource, class_name)
      return "#{class_name}Serializer".constantize if (class_name)
      lookup_serializer(resource)
    end

    def serialize_json_api(resource, serializer_options: {}, class_name: nil, serializer_class: nil)
      serializer = serializer_class || lookup_serializer(resource, class_name: class_name)
      serializer.new(resource, serializer_options).serializable_hash
    end

  end
end
