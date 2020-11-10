require "lp/serializable/utilities"
require "fast_jsonapi"

module Lp
  module Serializable
    module Strategies
      include Utilities
      include FastJsonapi

      private

      def serialize_hash(resource, options = {})
        serializer = "#{resource.class.name}Serializer".constantize
        options.merge!({ include: serializer.relationships_to_serialize.try(:keys) })
        serializer.new(resource, options).serializable_hash
      end

      def serializable_hash_with_class_name(resource, class_name, options = {})
        serializer = "#{class_name}Serializer".constantize
        options.merge!({ include: serializer.relationships_to_serialize.try(:keys) })
        serializer.new(resource, options).serializable_hash
      end

      def flatten_and_nest_data(hash, nested)
        nest_data?(flatten_hash(expose_data(hash), orig: hash), nested)
      end

      def flatten_array_and_nest_data(hash, nested)
        nest_data?(flatten_array_of_hashes(expose_data(hash), orig: hash), nested)
      end

      def collection?(boolean)
        { is_collection: boolean }
      end

      def set_nested_option(options)
        options.fetch(:nested, false)
      end
    end
  end
end
