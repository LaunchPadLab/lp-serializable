require "pry"

include Lp::Serializable

class User
  attr_reader :id, :name, :admin
  def initialize(id, name, admin=false)
    @id = id
    @name = name
    @admin = admin
  end
end

class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name
  
  attribute :display_name do |object|
    "#{object.id}: #{object.name}"
  end
  
  attribute :admin, if: Proc.new { |o| o.admin }
end

RSpec.describe Lp::Serializable do
  include_context "movie class"

  let(:user) { User.new(1, "Nathan") }
  let(:user_data) { { data: { id: 1, type: :user, name: "Nathan", display_name: "1: Nathan" } } }
  let(:nested_user_data) { { id: 1, type: :user, name: "Nathan", display_name: "1: Nathan" } }
  let(:users_data) do
    {
      data: [
        { id: 1, type: :user, name: "Nathan", display_name: "1: Nathan" },
        { id: 1, type: :user, name: "Nathan", display_name: "1: Nathan" },
      ],
    }
  end

  let(:nested_users_data) do
    [
      { id: 1, type: :user, name: "Nathan", display_name: "1: Nathan" },
      { id: 1, type: :user, name: "Nathan", display_name: "1: Nathan" },
    ]
  end

  describe "#serialize_and_flatten" do
    it "serialize a single resource, under [:data]" do
      result = serialize_and_flatten(user)
      expect(result).to eq(user_data)
    end

    # NOTE: Accessing data directly without any nested :data keys,
    # is the goal here
    it "serialize and flatten all relationships" do
      result = serialize_and_flatten(movie)
      expect(result[:data][:actors][0][:id]).to eq("1")
    end

    it "serializes a single nested resource, using nested: true option" do
      result = serialize_and_flatten(user, nested: true)
      expect(result).to eq(nested_user_data)
    end

    it "raises NameError, given a collection" do
      users = Array.new(2) { user }
      expect { serialize_and_flatten(users) }.to raise_error(NameError)
    end
    
    it "accepts options for conditional attributes" do
      user = User.new(2, "David", true)
      user_data = { data: { id: 2, type: :user, name: "David", display_name: "2: David", admin: true } }
      expect(serialize_and_flatten(user)).to eq(user_data)
    end
  end

  describe "#serialize_and_flatten_with_class_name" do
    it "serializes a single resource, given a class name under [:data]" do
      result = serialize_and_flatten_with_class_name(user, "User")
      expect(result).to eq(user_data)
    end

    # NOTE: Accessing data directly without any nested :data keys,
    # is the goal here
    it "serialize and flatten all relationships" do
      result = serialize_and_flatten_with_class_name(movie, "Movie")
      expect(result[:data][:actors][0][:id]).to eq("1")
      expect(result[:data][:actors][0][:name]).to eq("Test 1")
    end

    it "serializes a single nested resource, using nested: true option" do
      result = serialize_and_flatten_with_class_name(user, "User", nested: true)
      expect(result).to eq(nested_user_data)
    end

    it "raises UnserializableCollection, given a collection" do
      users = Array.new(2) { user }
      expect { serialize_and_flatten_with_class_name(users, "User") }.
        to raise_error(UnserializableCollection)
    end

    context "with custom attribute instead of has_many" do
      it "returns nested data" do
        result = serialize_and_flatten_with_class_name(movie, "LegacyMovie")
        expect(result[:data][:actors][0][:id]).to eq("1")
        expect(result[:data][:actors][0][:name]).to eq("Test 1")
      end
    end
  end

  describe "#serialize_and_flatten_collection" do
    it "serializes a collection, given a class name under [:data]" do
      users = Array.new(2) { user }
      result = serialize_and_flatten_collection(users, "User")
      expect(result).to eq(users_data)
    end

    # NOTE: Accessing data directly without any nested :data keys,
    # is the goal here
    it "serialize and flatten all relationships" do
      movies = build_movies(2)
      result = serialize_and_flatten_collection(movies, "Movie")
      expect(result[:data][0][:actors][0][:id]).to eq("1")
    end

    it "serializes a collection, using nested: true option" do
      users = Array.new(2) { user }
      result = serialize_and_flatten_collection(users, "User", nested: true)
      expect(result).to eq(nested_users_data)
    end

    it "serializes a single resource, given a class name under [:data]" do
      expect(serialize_and_flatten_with_class_name(user, "User")).
        to eq(user_data)
    end

    it "raises NameError, without a class name" do
      users = Array.new(2) { user }
      expect { serialize_and_flatten(users) }.to raise_error(NameError)
    end
  end
end
