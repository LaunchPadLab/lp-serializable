module Lp
  module Serializable
    module Utilities
      private

      REDUNDANT_KEYS = %i(attributes relationships)

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
        hash.each_with_object({}) do |(k, v), h|
          if hash_and_matches_redundant_keys?(v, k)
            flatten_hash(v).map do |h_k, h_v|
              h[h_k.to_s.to_sym] = h_v
            end
          # NOTE: extract this into a different method?
          elsif hash_and_has_data_key?(v)
            h[k] = expose_data(v)
          else
            h[k] = v
          end
        end
      end

      def hash_and_has_data_key?(value)
        value.is_a?(Hash) && value.key?(:data)
      end

      def hash_and_matches_redundant_keys?(value, key)
        value.is_a?(Hash) && REDUNDANT_KEYS.any?{|sym| sym == key}
      end
    end
  end
end