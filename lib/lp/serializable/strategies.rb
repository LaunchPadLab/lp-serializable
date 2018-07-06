require "lp/serializable/utilities"
require "fast_jsonapi"

module Lp
  module Serializable
    module Strategies
      include Utilities
      include FastJsonapi

      private

      def serialize_hash(resource, options={})
        "#{resource.class.name}Serializer"
          .constantize.new(resource, options).serializable_hash
      end

      def serializable_hash_with_class_name(resource, class_name, options={})
        "#{class_name}Serializer"
          .constantize.new(resource, options).serializable_hash
      end

      def flatten_and_nest_data(hash, nested)
        nest_data?(flatten_hash(expose_data(hash)), nested)
      end

      def flatten_array_and_nest_data(hash, nested)
        nest_data?(flatten_array_of_hashes(expose_data(hash)), nested)
      end
      
      def set_nested_option(options)
        options.fetch(:nested, false)
      end
    end
  end
end