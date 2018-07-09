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

### Controller Definition

```ruby
class ApplicationController < ActionController::Base
    include Lp::Serializable
end

class MoviesController < ApplicationController
    def index
        movies = Movie.all
        movies_hash = serialize_and_flatten_collection(movies, 'Movie')
        render json: movies_hash
    end

    def show
        movie = Movie.find(params[:id])
        movie_hash = serialize_and_flatten(movie)
        render json: movie
    end
end
```

### Serializer Definition

```ruby
class MovieSerializer
    include FastJsonapi::ObjectSerializer

    attributes :name, :year

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

### Sample Object

```ruby
movie = Movie.new
movie.id = 232
movie.name = 'test movie'
movie.actor_ids = [1, 2, 3]
movie.owner_id = 3
movie.movie_type_id = 1
movie
```

### Object Serialization

#### Return a hash
```ruby
hash = serialize_and_flatten(movie)
```

#### Output

```json
{
  "data": {
    "id": "3",
    "type": "movie",
    "name": "test movie",
    "year": null,
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

## Options Support

lp-serializable does not currently support fast_jsonapi's options hash when instantiating serializers. 

This affects serializing with [params](https://github.com/Netflix/fast_jsonapi#params), [compound documents](https://github.com/Netflix/fast_jsonapi#compound-document), metadata, and links.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lp-serializable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lp::Serializable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lp-serializable/blob/master/CODE_OF_CONDUCT.md).
