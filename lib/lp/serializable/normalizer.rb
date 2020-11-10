module Lp
  module Serializable
    class Normalizer

    # Service class that is initialized with a Json Api response body
    # Example:
    ## res = { 'id': 0, 'type': 'user', 'attributes': { 'name': 'Foo' } }
    ## user = Normalizer.new(res).normalize
    ## user[:name] -> 'Foo'

    attr_reader :serialized_hash, :include_paths

    def initialize(serialized_hash, **options)
      @serialized_hash = serialized_hash
      @include_paths = (options[:include] || []).map(&:to_s)
    end

    def normalize
      return unless serialized_hash
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
        obj[relationship_name] = populate_lookup_objects(relationship_name, lookup_objects)
      end
    end

    def populate_lookup_objects(resource_name, lookup_objects)
      lookup_objects.is_a?(Array) ? lookup_objects.map { |lookup_object| lookup_included_resource(resource_name, lookup_object) }
        : lookup_included_resource(resource_name, lookup_objects)
    end

    # Finds object in included array with matching id and type, falling back to lookup object
    def lookup_included_resource(resource_name, lookup_object)
      return lookup_object unless include_paths.find { |path| path == resource_name.to_s ||  path.start_with?("#{resource_name.to_s}.") }
      match = included_array.find { |obj| resource_matches?(obj, lookup_object) }
      normalize_included_resource(match || lookup_object, resource_name)
    end

    def normalize_included_resource(resource, resource_name)
      new_included_array = included_array
        .push(main_resource)
      new_include_paths = trim_include_paths(include_paths, resource_name)
      Normalizer.new({ data: resource, included: new_included_array }, { include: new_include_paths }).normalize
    end

    def trim_include_paths(paths, resource_name)
      resource_path = resource_name.to_s
      paths
        .select { |path| path != resource_path }
        .map { |path| path.sub("#{resource_path}.", "") }
    end

    # Returns true when type and id are identical
    def resource_matches?(a, b)
      a[:id] === b[:id] && a[:type] === b[:type]
    end

    end
  end
end
