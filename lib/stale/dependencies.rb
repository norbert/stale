module Stale
  module Dependencies
    def register_dependencies(key_array)
      model_keys = models_from_key(key_array)
      key_string = key_as_string(key_array)

      model_keys.each do |model_key|
        register_dependency(model_key, key_string)
      end
    end

    def expire_dependencies(model_key)
      expire_dependencies_from_list(dependency_key_for_instance(model_key))
      expire_dependencies_from_list(dependency_key_for_collection(model_key))
    end

    def register_dependency(model_key, key_string)
      add_dependency_to_list(dependency_key_for_instance(model_key), key_string)
    end

    def dependency_key_for_instance(model_key)
      model_key + Stale.configuration[:dependency_key_suffix]
    end

    def dependency_key_for_collection(model_key)
      collection_from_key(model_key) + Stale.configuration[:dependency_key_suffix]
    end

    def add_dependency_to_list(dependency_key, key_string)
      Stale.cache.modify(dependency_key) do |dependency_list|
        (Array(dependency_list) << key_string).uniq
      end
    end

    def expire_dependencies_from_list(dependency_key)
      Stale.cache.delete(*Array(Stale.cache.get(dependency_key)))
    end
  end
end
