module Stale
  module Interface
    include Dependencies

    extend self

    def key_for_parameters(parameters, controller)
      Stale.configuration.key_for_parameters(parameters, controller)
    end

    def key_for_model(collection, id = nil, *args)
      [key_for_collection(collection), id, *args].join(Stale.configuration[:model_key_separator])
    end

    def key_for_collection(collection)
      collection.is_a?(Class) ? collection.name.underscore : collection
    end

    def key_as_string(key_array)
      Array(key_array).join(Stale.configuration[:key_separator])
    end

    def models_from_key(key_array)
      key_array.select { |key_part| key_part.include?(Stale.configuration[:model_key_separator]) }
    end

    def collection_from_key(model_key)
      key_for_model(model_key.split(Stale.configuration[:model_key_separator], 2).first)
    end
  end
end
