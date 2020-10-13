module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def self.search_project(query, project)
      __elasticsearch__.search(
        {
          query: {
            bool: {
              must: {
                query_string: {
                  query: "*#{query}*"
                }
              },
              filter: {
                term: {
                  project_id: project.id
                }
              }
            }
          }
        }
      )
    end
  end
end
