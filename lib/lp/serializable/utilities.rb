module Lp
  module Serializable
    module Utilities
      private

      REDUNDANT_KEYS = %i[attributes relationships].freeze

      def nest_data?(resource, nested)
        if nested
          resource
        else
          nest_resource_under_data_key(resource)
        end
      end

      def flatten_array_of_hashes(array)
        array.map do |hash|
          flatten_hash(hash)
        end
      end

      def expose_data(hash)
        hash[:data]
      end

      def nest_resource_under_data_key(resource)
        hash = new_hash
        hash[:data] = resource
        hash
      end

      def new_hash
        Hash.new(0)
      end

      def flatten_hash(hash)
        return unless hash
        hash.each_with_object({}) do |(key, value), h|
          if hash_and_matches_redundant_keys?(key, value)
            flatten_hash_map(value, h)
          elsif hash_and_has_data_key?(value)
            h[key] = expose_data(value)
          else
            h[key] = value
          end
        end
      end

      def flatten_hash_map(value, hash)
        flatten_hash(value).map do |h_k, h_v|
          hash[h_k.to_s.to_sym] = h_v
        end
      end

      def hash_and_has_data_key?(value)
        value.is_a?(Hash) && value.key?(:data)
      end

      # NOTE Supports native relationship references in serializer
      def hash_and_matches_redundant_keys?(key, value)
        value.is_a?(Hash) && REDUNDANT_KEYS.any? { |sym| sym == key }
      end
    end
  end
end
