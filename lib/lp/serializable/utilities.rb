module Lp
  module Serializable
    module Utilities
      private

      REDUNDANT_KEYS = %i[attributes included].freeze

      def nest_data?(resource, nested)
        if nested
          resource
        else
          nest_resource_under_data_key(resource)
        end
      end

      def flatten_array_of_hashes(array, orig: nil)
        array.map do |hash|
          flatten_hash(hash, orig: orig)
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

      def flatten_hash(hash, orig: nil)
        return unless hash
        result = {}
        hash.each do |key, value|
          if hash_and_matches_redundant_keys?(key, value)
            flatten_hash_map(value, result)
          elsif is_included_hash?(key, value)
            flatten_included(value, hash, result, orig)
          elsif hash_and_has_data_key?(value)
            result[key] = expose_data(value)
          else
            result[key] = value
          end
        end
        result
      end

      def flatten_hash_map(value, hash)
        flatten_hash(value).map do |h_k, h_v|
          hash[h_k.to_s.to_sym] = h_v
        end
      end

      # NEW

      def flatten_included(included, original_hash, result, orig)
        included.each do |key, value|
          result[key] = relationship(original_hash, key, orig).map do |thing|
            flatten_hash(thing, orig: orig)
          end
        end
      end

      def has_relationship?(hash, name)
        (hash[:relationships] || {}).key?(name)
      end
  
      # If relationship is defined, returns the resources for that relationship.
      # If full resources are not included, falls back to the lookup object ({ id, type })
      def relationship(hash, name, orig)
        return unless has_relationship?(hash, name)
        relationship = (hash[:relationships] || {})[name]
        return {} if relationship.empty?
        lookup_objects = relationship[:data]
        # Look up included resources, mapping if there's an array of them
        lookup_objects.is_a?(Array) ?
          lookup_objects.map { |lookup_object| lookup_included_resource(orig, lookup_object) }
          : lookup_included_resource(orig, lookup_objects)
      end

      # Finds object in included array with matching id and type, falling back to lookup object
      def lookup_included_resource(orig, lookup_object)
        if (!orig[:included]) 
          raise('Trying to lookup')
        end
        match = orig[:included].find { |obj| resource_matches?(obj, lookup_object) }
        match || lookup_object
      end

          # Returns true when type and id are identical
    def resource_matches?(a, b)
      a[:id] === b[:id] && a[:type] === b[:type]
    end


      def hash_and_has_data_key?(value)
        value.is_a?(Hash) && value.key?(:data)
      end

      def is_included_hash?(key, value)
        value.is_a?(Hash) && key == :relationships
      end

      # NOTE Supports native relationship references in serializer
      def hash_and_matches_redundant_keys?(key, value)
        value.is_a?(Hash) && REDUNDANT_KEYS.any? { |sym| sym == key }
      end
    end
  end
end
