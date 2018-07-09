require 'pry'

include Lp::Serializable

class User
  attr_reader :id, :name
  def initialize(id, name)
    @id = id
    @name = name
  end
end

class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name
end

RSpec.describe Lp::Serializable do
  include_context 'movie class'

  let(:user) { User.new(1, 'Nathan') }
  let(:user_data){ {:data=>{:id=>1, :type=>:user, :name=>"Nathan"}} }
  let(:nested_user_data){ {:id=>1, :type=>:user, :name=>"Nathan"} }
  let(:users_data) do 
    {
      :data => [
        {:id=>1, :type=>:user, :name=>"Nathan"},
        {:id=>1, :type=>:user, :name=>"Nathan"}
      ]      
    } 
  end

  let(:nested_users_data) do 
    [
      {:id=>1, :type=>:user, :name=>"Nathan"},
      {:id=>1, :type=>:user, :name=>"Nathan"}
    ]
  end

  context "#serialize_and_flatten" do
    it "serialize a single resource, under [:data]" do
      result = serialize_and_flatten(user)
      expect(result).to eq(user_data)
    end

# NOTE: Accessing data directly without any nested :data keys is the goal here
    it 'serialize and flatten all relationships' do
      result = serialize_and_flatten(movie)
      expect(result[:data][:actors][0][:id]).to eq('1')
    end

    it "serializes a single nested resource, using nested: true option" do
      result = serialize_and_flatten(user, nested: true)
      expect(result).to eq(nested_user_data)
    end

    it "raises NameError, given a collection" do
      users = 2.times.map { user }
      expect { serialize_and_flatten(users) }.to raise_error(NameError)
    end
  end

  context "#serialize_and_flatten_with_class_name" do
    it "serializes a single resource, given a class name under [:data]" do
      result = serialize_and_flatten_with_class_name(user, 'User')
      expect(result).to eq(user_data)
    end

# NOTE: Accessing data directly without any nested :data keys is the goal here
    it 'serialize and flatten all relationships' do
      result = serialize_and_flatten_with_class_name(movie, 'Movie')
      expect(result[:data][:actors][0][:id]).to eq('1')
    end

    it "serializes a single nested resource, using nested: true option" do
      result = serialize_and_flatten_with_class_name(user, 'User', nested: true)
      expect(result).to eq(nested_user_data)
    end

    it "raises UnserializableCollection,given a collection" do
      users = 2.times.map { user }
      expect { serialize_and_flatten_with_class_name(users, 'User') }
      .to raise_error(UnserializableCollection)
    end
  end

  context "#serialize_and_flatten_collection" do
    it "serializes a collection, given a class name under [:data]" do
      users = 2.times.map { user }
      result = serialize_and_flatten_collection(users, 'User')
      expect(result).to eq(users_data)
    end

# NOTE: Accessing data directly without any nested :data keys is the goal here
    it 'serialize and flatten all relationships' do
      movies = build_movies(2)
      result = serialize_and_flatten_collection(movies, 'Movie')
      expect(result[:data][0][:actors][0][:id]).to eq('1')
    end

    it "serializes a collection, using nested: true option" do
      users = 2.times.map { user }
      result = serialize_and_flatten_collection(users, 'User', nested: true)
      expect(result).to eq(nested_users_data)
    end

    it "serializes a single resource, given a class name under [:data]" do
      expect( serialize_and_flatten_with_class_name(user, 'User') )
      .to eq(user_data)
    end

    it "raises NameError, without a class name" do
      users = 2.times.map { user }
      expect { serialize_and_flatten(users) }.to raise_error(NameError)
    end
  end
end
