# Lp::Serializable

When serializing with [fast_jsonapi](https://github.com/Netflix/fast_jsonapi), data is structured per the json-api [specs](http://jsonapi.org/format/).

lp-serializable is a thin wrapper around fast_jsonapi serialization, producting AMS style output.

lp-serializable is intended to be used in Rails controllers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lp-serializable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lp-serializable

## Usage

**Controller Definition**

```ruby
class ApplicationController < ActionController::Base
  include Lp::Serializable
end

class MoviesController < ApplicationController
  def index
    movies = Movie.all
    movies_hash = serializable_collection(movies, 'Movie')
    render json: movies_hash
  end

  def show
    movie = Movie.find(params[:id])
    movie_hash = serializable(movie)
    render json: movie_hash
  end
end
```

**Serializer Definition**

```ruby
class MovieSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name
  
  attribute :year, if: Proc.new { |object| object.year.present? }
  
  attribute :last_updated do |object|
    object.updated_at
  end

  has_many :actors
  belongs_to :owner
end

class ActorSerializer
  include FastJsonapi::ObjectSerializer
    
  attributes :id
end

class OwnerSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id
end
```

## Object Serialization
**Sample Object**

```ruby
movie = Movie.new
movie.id = 232
movie.name = 'test movie'
movie.actor_ids = [1, 2, 3]
movie.owner_id = 3
movie.movie_type_id = 1
movie
```

**Return a hash**
```ruby
hash = serializable(movie)
```

**Output**

```json
{
  "data": {
    "id": "3",
    "type": "movie",
    "name": "test movie",
    "last_updated": "2019-04-26 18:55:46 UTC",
    "actors": [
        {
            "id": "1",
            "type": "actor"
        },
        {
            "id": "2",
            "type": "actor"
        }
    ],
    "owner": {
        "id": "3",
        "type": "user"
    }
  }
}

```

For more information on configuration, refer to [fast_jsonapi](https://github.com/Netflix/fast_jsonapi#customizable-options) documentation.

## Deeply Nested Serialization Pattern

Fastjson API does not support serialization of deeply nested resources.

To get around this, extend `Lp::Serializable` in your serializers:

```ruby
class MovieSerializer
  include FastJsonapi::ObjectSerializer
  extend Lp::Serializable

 ...
end
```

Define custom attributes for relationships, instead of defining them via fastjson_api:

```ruby
class MovieSerializer
  include FastJsonapi::ObjectSerializer
  extend Lp::Serializable

 attribute :actors do |object|
  collection = object.actors
  serializer = 'Actor'
  serializable_collection(collection, serializer, nested: true)
 end
end
```

Attribute `:actors` will trigger `ActorSerializer` to serialize the actors collection. Consequently, any relationships defined in `ActorSerializer` via custom attributes and serialized with `serializable_` methods (using the `nested: true` option) will be appropriately nested.

## Custom Serializer Class

Use `#serializable_class` to serialize with a custom class:

```ruby
  def show
    movie = Movie.find(params[:id])
    # Will serialize with FilmSerializer instead of MovieSerializer
    movie_hash = serializable_class(movie, 'Film')
    render json: movie_hash
  end
```

## Options Support

Supported options include:

- `:fields` ([Sparse Fieldsets](https://github.com/Netflix/fast_jsonapi#sparse-fieldsets))
- `:params` ([Params](https://github.com/Netflix/fast_jsonapi#params))
- [Conditional Attributes](https://github.com/Netflix/fast_jsonapi#conditional-attributes)

Other options are "supported" but may yeild unexpected results, as Serializable's hash flattening prioritizes deeply nested data structures.

`:is_collection` is baked into Seriazable methods for accurate detection of collections or singular resources.

## Aliases

- `serialize_and_flatten()` = `serializable()`
- `serialize_and_flatten_with_class_name()` = `serializable_class()`
- `serialize_and_flatten_collection()` = `serializable_collection()`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LaunchPadLab/lp-serializable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lp::Serializable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/LaunchPadLab/lp-serializable/blob/master/CODE_OF_CONDUCT.md).
