include Lp::Serializable

describe 'normalizer' do

  let (:fixtures) { Fixtures::NormalizerFixtures.new }

  describe '#normalize' do

    let(:json) { raise 'Define in context' }
    let(:result) { Normalizer.new(json).normalize }

    context 'when nil is passed' do 
      let(:json) { nil }
      it 'returns nil' do
        expect(result).to eq(nil)
      end
    end

    context 'without included param' do 
      let(:json) { { data: fixtures.user2[:json] }}
      it 'flattens attributes' do
        expect(result).to eq(fixtures.user2[:modelWithoutIncluded])
      end
    end
  end


  # it 'should deserialize collection with included' do
  #     const townsCollection = jsona.deserialize({
  #         data: [town1.json, town2.json],
  #         included: [country1.json, country2.json]
  #     end
  #     expect(townsCollection).to.be.deep.equal([town1.model, town2.model]);
  # end

  # it 'should deserialize json with circular relationships' do
  #     const recursiveItem = jsona.deserialize(circular.json);
  #     expect(recursiveItem).to.be.deep.equal(circular.model);
  # end

  # it 'should deserialize json with duplicate relationships' do
  #     const duplicateItem = jsona.deserialize(duplicate.json, { preferNestedDataFromData: true });
  #     expect(duplicateItem).to.be.deep.equal(duplicate.model);
  # end

  # it 'should deserialize json with data without root ids' do
  #     const collectionWithoutRootIds = jsona.deserialize({data: withoutRootIdsMock.json});
  #     expect(collectionWithoutRootIds).to.be.deep.equal(withoutRootIdsMock.collection);
  # end

  # it 'should deserialize json and save null relationships' do
  #     const collectionWithNullRelations = jsona.deserialize({data: withNullRelationsMock.json});
  #     expect(collectionWithNullRelations).to.be.deep.equal(withNullRelationsMock.collection);
  # end

  # it 'should deserialize resource id object meta field into resourceIdObjMeta' do
  #     const stuff = jsona.deserialize(resourceIdObjMetaMock.json);
  #     expect(stuff).to.be.deep.equal(resourceIdObjMetaMock.collection);
  # end

end