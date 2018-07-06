module Lp
  module Serializable
    module Utilities
      private

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
          if v.is_a?(Hash) && k == :attributes
            flatten_hash(v).map do |h_k, h_v|
              h["#{h_k}".to_sym] = h_v
            end
          else 
            h[k] = v
          end
        end
      end
    end
  end
end