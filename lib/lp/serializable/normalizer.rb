module Lp
  module Serializable
    class Normalizer

    # Service class that is initialized with a Json Api response body
    # Example:
    ## res = { 'id': 0, 'type': 'user', 'attributes': { 'name': 'Foo' } }
    ## user = Normalizer.new(res).normalize
    ## user[:name] -> 'Foo'

    attr_reader :serialized_hash

    def initialize(serialized_hash)
      raise "Requires serialized hash to be present" unless serialized_hash.present?
      @serialized_hash = serialized_hash
    end

    def normalize
      normalize_resource_or_resources(main_resource)
    end

    private

    def normalize_resource_or_resources(resource_or_resources)
      resource_or_resources.is_a?(Array) ? normalize_array(resource_or_resources) 
      : normalize_single_resource(resource_or_resources)
    end

    def normalize_array(resources)
      resources.map { |r| normalize_single_resource(r) }
    end

    def normalize_single_resource(resource)
      base = {
        id: resource[:id],
        type: resource[:type],
      }
      attributes = resource[:attributes] || {}
      relationships = populate_relationships(resource[:relationships] || {})
      base
        .merge(attributes)
        .merge(relationships)
    end
  

    # The resource nested under "data" in the response hash is the main one.
    def main_resource
      serialized_hash[:data]
    end

    def included_array
      serialized_hash[:included] || []
    end

    def populate_relationships(relationships)
      relationships.each_with_object({}) do |(relationship_name, relationship), obj|
        next {} if relationship.empty?
        lookup_objects = relationship[:data]
        looked_up_resources = populate_lookup_objects(lookup_objects)
        obj[relationship_name] = normalize_resource_or_resources(looked_up_resources)
      end
    end

    def populate_lookup_objects(lookup_objects)
      lookup_objects.is_a?(Array) ? lookup_objects.map { |lookup_object| lookup_included_resource(lookup_object) }
        : lookup_included_resource(lookup_objects)
    end

    # Finds object in included array with matching id and type, falling back to lookup object
    def lookup_included_resource(lookup_object)
      match = included_array.find { |obj| resource_matches?(obj, lookup_object) }
      match || lookup_object
    end

    # Returns true when type and id are identical
    def resource_matches?(a, b)
      a[:id] === b[:id] && a[:type] === b[:type]
    end

    end
  end
end
