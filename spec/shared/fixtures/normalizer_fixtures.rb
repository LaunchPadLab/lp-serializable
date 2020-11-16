module Fixtures
  class NormalizerFixtures

    # Copied from https://github.com/olosegres/jsona/blob/master/tests/mocks.ts

    def country2
      {
        model: {
            type: 'country',
            id: '34',
            name: 'Spain',
        },
        json: {
            type: 'country',
            id: '34',
            attributes: {
                name: 'Spain',
            }
        }
      }
    end
    
    def country1
      {
        model: {
            type: 'country',
            id: '86',
            name: 'China',
        },
        json: {
            type: 'country',
            id: '86',
            attributes: {
                name: 'China',
            }
        }
      }
    end
    
    def town1
      {
        model: {
            type: 'town',
            id: '21',
            name: 'Shanghai',
            country: country1[:model],
            relationshipNames: ['country']
        },
        json: {
            type: 'town',
            id: '21',
            attributes: {
                name: 'Shanghai',
            },
            relationships: {
                country: {
                    data: {
                        type: 'country',
                        id: country1[:model][:id],
                    }
                }
            }
        }
      }
    end
    
    def town2
      {
        model: {
            type: 'town',
            id: '80',
            name: 'Barcelona',
            country: country2[:model],
            relationshipNames: ['country']
        },
        json: {
            type: 'town',
            id: '80',
            attributes: {
                name: 'Barcelona',
            },
            relationships: {
                country: {
                    data: {
                        type: 'country',
                        id: country2[:model][:id],
                    }
                }
            }
        }
      }
    end
    
    def specialty1
      {
        model: {
            type: 'specialty',
            id: '1',
            title: 'mycategory1'
        },
        json: {
            type: 'specialty',
            id: '1',
            attributes: {
                title: 'mycategory1'
            }
        }
      }
    end
    
    def specialty2
      {
        model: {
            type: 'specialty',
            id: '2',
            title: 'mycategory2'
        },
        json: {
            type: 'specialty',
            id: '2',
            attributes: {
                title: 'mycategory2'
            }
        }
      }
    end
    
    # def user1
    #   {
    #     model: {
    #         type: 'user',
    #         id: '1',
    #         name: 'myName1',
    #         active: false,
    #         town: town1.model,
    #         specialty: [specialty1.model],
    #         relationshipNames: ['town', 'specialty']
    #     },
    #     json: {
    #         type: 'user',
    #         id: '1',
    #         attributes: {
    #             name: 'myName1',
    #             active: false,
    #         },
    #         relationships: {
    #             town: {
    #                 data: {
    #                     type: 'town',
    #                     id: town1.model.id,
    #                 }
    #             },
    #             specialty: {
    #                 data: [{
    #                     type: 'specialty',
    #                     id: specialty1.model.id
    #                 }]
    #             }
    #         }
    #     },
    #     included: {
    #         townOnly: [
    #             town1.json
    #         ]
    #     }
    #   }
    # end
    
    def user2
      {
        model: {
            type: 'user',
            id: '2',
            name: 'myName2',
            active: true,
            town: town2[:model],
            specialty: [specialty1[:model], specialty2[:model]],
            # relationshipNames: ['town', 'specialty']
        },
        modelWithoutIncluded: {
            type: 'user',
            id: '2',
            name: 'myName2',
            active: true,
            town: {
                id: town2[:model][:id],
                type: town2[:model][:type],
            },
            specialty: [{
                id: specialty1[:model][:id],
                type: specialty1[:model][:type],
            }, {
                id: specialty2[:model][:id],
                type: specialty2[:model][:type],
            }],
            # TODO
            # relationshipNames: ['town', 'specialty']
        },
        json: {
            type: 'user',
            id: '2',
            attributes: {
                name: 'myName2',
                active: true,
            },
            relationships: {
                town: {
                    data: {
                        type: 'town',
                        id: town2[:model][:id,]
                    }
                },
                specialty: {
                    data: [{
                        type: 'specialty',
                        id: specialty1[:model][:id]
                    }, {
                        type: 'specialty',
                        id: specialty2[:model][:id]
                    }]
                }
            }
        },
        includeNames: {
            townOnly: ['town']
        },
        included: {
            townOnly: [
                town2[:json]
            ]
        }
      }
    end
    
    # def article1
    #   {
    #     model: {
    #         type: 'article',
    #         id: 1,
    #         likes: 5550,
    #         author: user1.model,
    #         country: country1.model,
    #         relationshipNames: ['author', 'country']
    #     },
    #     json: {
    #         type: 'article',
    #         id: 1,
    #         attributes: {
    #             likes: 5550
    #         },
    #         relationships: {
    #             author: {
    #                 data: {
    #                     type: 'user',
    #                     id: user1.model.id
    #                 }
    #             },
    #             country: {
    #                 data: {
    #                     type: 'country',
    #                     id: country1.model.id
    #                 }
    #             }
    #         }
    #     }
    #   }
    # end
    
    # def article2
    #   {
    #     model: {
    #         type: 'article',
    #         id: 2,
    #         likes: 100,
    #         author: user2.model,
    #         country: country2.model,
    #         relationshipNames: ['author', 'country']
    #     },
    #     json: {
    #         type: 'article',
    #         id: 2,
    #         attributes: {
    #             likes: 100
    #         },
    #         relationships: {
    #             author: {
    #                 data: {
    #                     type: 'user',
    #                     id: user2.model.id,
    #                 }
    #             },
    #             country: {
    #                 data: {
    #                     type: 'country',
    #                     id: country2.model.id,
    #                 }
    #             }
    #         }
    #     },
    #     includeNames: [
    #         'author.town.contry',
    #         'author.specialty',
    #         'country'
    #     ],
    #   }
    # end
    
    # def articleWithoutAuthor
    #   {
    #     model: {
    #         type: 'article',
    #         id: 3,
    #         likes: 0,
    #         author: null,
    #         relationshipNames: ['author']
    #     },
    #     json: {
    #         type: 'article',
    #         id: 3,
    #         attributes: {
    #             likes: 0,
    #         },
    #         relationships: {
    #             author: {
    #                 data: null,
    #             },
    #         },
    #     },
    #     includeNames: [
    #         'author'
    #     ],
    #   }
    # end
    
    # const circularModel = {
    #     type: 'model',
    #     id: '1',
    #     relationshipNames: ['simpleRelation'],
    #   }
    # end
    
    # const circularSubmodel = {
    #     type: 'subModel',
    #     id: '1',
    #     relationshipNames: ['circularRelation'],
    #   }
    # end
    
    # circularModel['simpleRelation'] = circularSubmodel;
    # circularSubmodel['circularRelation'] = circularModel;
    
    # def circular
    #   {
    #     model: circularModel,
    #     json: {
    #         "data": {
    #             "type": "model",
    #             "id": "1",
    #             "relationships": {
    #                 "simpleRelation": {
    #                     "data": {
    #                         "type": "subModel",
    #                         "id": "1"
    #                     }
    #                 },
    #             }
    #         },
    #         "included": [
    #             {
    #                 "type": "subModel",
    #                 "id": "1",
    #                 "relationships": {
    #                     "circularRelation": {
    #                         "data": {
    #                             "type": "model",
    #                             "id": "1"
    #                         }
    #                     }
    #                 }
    #             }
    #         ]
    #     },
    #   }
    # end
    
    # const duplicateModels = [
    #     {
    #         type: 'model',
    #         id: '1',
    #         'relationshipNames': [
    #             'simpleRelation'
    #         ],
    #     },
    #     {
    #         type: 'model',
    #         id: '2',
    #         'relationshipNames': [
    #             'simpleRelation'
    #         ],
    #     },
    # ];
    
    # const duplicateSubModel = {
    #     'type': 'subModel',
    #     'id': '1',
    #     'relationshipNames': [
    #         'simpleRelation2'
    #     ],
    #   }
    # end
    
    # duplicateModels[0]['simpleRelation'] = duplicateSubModel;
    # duplicateModels[1]['simpleRelation'] = duplicateSubModel;
    # duplicateSubModel['simpleRelation2'] = [
    #   duplicateModels[0],
    #   duplicateModels[1],
    # ];
    
    # def duplicate
    #   {
    #     model: duplicateModels,
    #     json: {
    #         'data': [
    #             {
    #                 'type': 'model',
    #                 'id': '1',
    #                 'relationships': {
    #                     'simpleRelation': {
    #                         'data': {
    #                             'type': 'subModel',
    #                             'id': '1'
    #                         }
    #                     },
    #                 }
    #             },
    #             {
    #                 'type': 'model',
    #                 'id': '2',
    #                 'relationships': {
    #                     'simpleRelation': {
    #                         'data': {
    #                             'type': 'subModel',
    #                             'id': '1'
    #                         }
    #                     },
    #                 }
    #             }
    #         ],
    #         'included': [
    #             {
    #                 'type': 'subModel',
    #                 'id': '1',
    #                 'relationships': {
    #                     'simpleRelation2': {
    #                         'data': [
    #                             {
    #                                 'type': 'model',
    #                                 'id': '1'
    #                             },
    #                             {
    #                                 'type': 'model',
    #                                 'id': '2'
    #                             }
    #                         ]
    #                     }
    #                 }
    #             },
    #             {
    #                 'type': 'model',
    #                 'id': '1',
    #             },
    #             {
    #                 'type': 'model',
    #                 'id': '2',
    #             }
    #         ]
    #     },
    #   }
    # end
    
    # def includeNames1
    #   {
    #     denormalized: [
    #         'articles.author.town.country',
    #         'articles.country',
    #         'country',
    #     ],
    #     normalized: {
    #         country: null,
    #         articles: {
    #             author: {
    #                 town: {
    #                     country: null
    #                 }
    #             },
    #             country: null
    #         }
    #     }
    #   }
    # end
    
    # def reduxObject1
    #   {
    #     "article": {
    #         "1": {
    #             "id": 1,
    #             "attributes": {"likes": 5550},
    #             "relationships": {
    #                 "author": {"data": {"id": '1', "type": "user"}},
    #                 "country": {"data": {"id": '86', "type": "country"}}
    #             }
    #         },
    #         "2": {
    #             "id": 2,
    #             "attributes": {"likes": 100},
    #             "relationships": {
    #                 "author": {"data": {"id": '2', "type": "user"}},
    #                 "country": {"data": {"id": '34', "type": "country"}}
    #             }
    #         }
    #     },
    #     "country": {
    #         "34": {"id": '34', "attributes": {"name": "Spain"}},
    #         "86": {"id": '86', "attributes": {"name": "China"}}},
    #     "specialty": {
    #         "1": {"id": "1", "attributes": {"title": "mycategory1"}},
    #         "2": {"id": "2", "attributes": {"title": "mycategory2"}}
    #     },
    #     "town": {
    #         "21": {
    #             "id": '21',
    #             "attributes": {"name": "Shanghai"},
    #             "relationships": {"country": {"data": {"id": '86', "type": "country"}}}
    #         },
    #         "80": {
    #             "id": '80',
    #             "attributes": {"name": "Barcelona"},
    #             "relationships": {"country": {"data": {"id": '34', "type": "country"}}}
    #         }
    #     },
    #     "user": {
    #         "1": {
    #             "id": '1',
    #             "attributes": {"name": "myName1", "active": false},
    #             "relationships": {
    #                 "town": {"data": {"id": '21', "type": "town"}},
    #                 "specialty": {
    #                     "data": [{"id": "1", "type": "specialty"}]
    #                 }
    #             }
    #         },
    #         "2": {
    #             "id": '2',
    #             "attributes": {"name": "myName2", "active": true},
    #             "relationships": {
    #                 "town": {
    #                     "data": {"id": '80', "type": "town"}},
    #                 "specialty": {
    #                     "data": [
    #                         {"id": "1", "type": "specialty"},
    #                         {"id": "2", "type": "specialty"}
    #                     ]
    #                 }
    #             }
    #         }
    #     }
    #   }
    # end
    
    # def reduxObjectWithCircular
    #   {
    #     model: {
    #         '1': {
    #             "id": "1",
    #             "relationships": {
    #                 "simpleRelation": {
    #                     "data": {
    #                         "type": "subModel",
    #                         "id": "1"
    #                     }
    #                 },
    #             }
    #         }
    #     },
    #     subModel: {
    #         '1': {
    #             "id": "1",
    #             "relationships": {
    #                 "circularRelation": {
    #                     "data": {
    #                         "type": "model",
    #                         "id": "1"
    #                     }
    #                 },
    #             }
    #         }
    #     },
    #   }
    # end
    
    
    # def withoutRootIdsMock
    #   {
    
    #     json: [{
    #         "type": "language-knowledges",
    #         "relationships": {
    #             "sourceLanguage": {
    #                 "data": {
    #                     "type": "source-languages",
    #                     "id": "11"
    #                 }
    #             },
    #             "workArea": {
    #                 "data": {
    #                     "type": "work-areas",
    #                     "id": "22"
    #                 }
    #             }
    #         }
    #     }, {
    #         "type": "language-knowledges",
    #         "relationships": {
    #             "sourceLanguage": {
    #                 "data": {
    #                     "type": "source-languages",
    #                     "id": "22"
    #                 }
    #             },
    #             "workArea": {
    #                 "data": {
    #                     "type": "work-areas",
    #                     "id": "22"
    #                 }
    #             }
    #         }
    #     }],
    
    #     collection: [{
    #         type: 'language-knowledges',
    #         id: undefined,
    #         sourceLanguage: {
    #             type: 'source-languages',
    #             id: '11'
    #         },
    #         workArea: {
    #             type: 'work-areas',
    #             id: '22'
    #         },
    #         relationshipNames: [ 'sourceLanguage', 'workArea' ]
    #     }, {
    #         type: 'language-knowledges',
    #         id: undefined,
    #         sourceLanguage: {
    #             type: 'source-languages',
    #             id: '22'
    #         },
    #         workArea: {
    #             type: 'work-areas',
    #             id: '22'
    #         },
    #         relationshipNames: [ 'sourceLanguage', 'workArea' ]
    #     }],
    
    #   }
    # end
    
    # def withNullRelationsMock
    #   {
    
    #     json: [{
    #         "type": "category",
    #         "id": "3",
    #         "attributes": {
    #             "slug": "ya"
    #         },
    #         "relationships": {
    #             "parent": {
    #                 "data": {
    #                     "type": "category",
    #                     "id": "0"
    #                 }
    #             }
    #         }
    #     }, {
    #         "type": "category",
    #         "id": "0",
    #         "attributes": {
    #             "slug": "home"
    #         },
    #         "relationships": {
    #             "parent": {
    #                 "data": null
    #             }
    #         }
    #     }],
    
    #     collection: [{
    #         "type": "category",
    #         "id": "3",
    #         "slug": "ya",
    #         "parent": {
    #             "type": "category",
    #             "id": "0",
    #             "slug": "home",
    #             "parent": null,
    #             "relationshipNames": [
    #                 "parent"
    #             ]
    #         },
    #         "relationshipNames": [
    #             "parent"
    #         ]
    #     }, {
    #         "type": "category",
    #         "id": "0",
    #         "slug": "home",
    #         "parent": null,
    #         "relationshipNames": [
    #             "parent"
    #         ]
    #     }],
    
    #   }
    # end
    
    # def resourceIdObjMetaMock
    #   {
    
    #     json: {
    #         "data": [{
    #             "type": "node--site_configuration",
    #             "id": "f8895943-7f51-451b-bb8f-a479853f1b4b",
    #             "attributes": {
    #                 "langcode": "en",
    #                 "title": "Site Configuration"
    #             },
    #             "relationships": {
    #                 "field_logo": {
    #                     "data": {
    #                         "type": "file--file",
    #                         "id": "551ec1b9-b0c6-4649-bb7c-b6ebb09354ff",
    #                         "meta": {
    #                             "alt": "ACME Corp Logo",
    #                             "title": "",
    #                             "width": 206,
    #                             "height": 278
    #                         }
    #                     }
    #                 }
    #             }
    #         }],
    #         "included": [{
    #             "type": "file--file",
    #             "id": "551ec1b9-b0c6-4649-bb7c-b6ebb09354ff",
    #             "attributes": {
    #                 "langcode": "en",
    #                 "uri": {
    #                     "value": "public://2020-07/acmecorp-logo-colour-2x.png",
    #                     "url": "http://acmecorp.oss-cn-hongkong.aliyuncs.com/s3fs-public/2020-07/acmecorp-logo-colour-2x.png"
    #                 },
    #                 "filemime": "image/png",
    #                 "filesize": 54952
    #             }
    #         }]
    #     },
    
    #     collection: [{
    #         "type": "node--site_configuration",
    #         "id": "f8895943-7f51-451b-bb8f-a479853f1b4b",
    #         "langcode": "en",
    #         "title": "Site Configuration",
    #         "field_logo": {
    #             "resourceIdObjMeta": {
    #                 "alt": "ACME Corp Logo",
    #                 "height": 278,
    #                 "title": "",
    #                 "width": 206,
    #             },
    #             "type": "file--file",
    #             "id": "551ec1b9-b0c6-4649-bb7c-b6ebb09354ff",
    #             "langcode": "en",
    #             "uri": {
    #                 "value": "public://2020-07/acmecorp-logo-colour-2x.png",
    #                 "url": "http://acmecorp.oss-cn-hongkong.aliyuncs.com/s3fs-public/2020-07/acmecorp-logo-colour-2x.png"
    #             },
    #             "filemime": "image/png",
    #             "filesize": 54952,
    #         },
    #         "relationshipNames": [
    #             "field_logo"
    #         ],
    #     }],
    
    #   }
    # end
  end
end

