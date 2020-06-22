# frozen_string_literal: true

# Modelize imported recipes.
# Attributes:
#  - name:            String - Name of the recipe
#  - people_quantity: Integer - People number the recipe is made for
#  - image:           String - URL of the recipe image
#  - tags:            Array of string - List of assigned tags, like meal type
#  - ingredients:     Array of string - List of all necessary ingredients

class Recipe < ApplicationRecord
  MEAL = ['Plat principal', 'Dessert', 'Entrée'].freeze

  scope :for_meal, ->(meal) { where('tags @> ARRAY[?]', meal) }
  scope :for_people, ->(number) { where('people_quantity >= ?', number) }


  scope :with_matching_ingredients, ->(list) do
    list_to_use = useable_list(list)
    # Sub_query catches all records matching built regex.
    # regexp_matches is a postgresql function returning matching substrings.
    sub_query = select("
      id, name, image, ingredients, people_quantity, tags,
      regexp_matches(ingredients::TEXT, '(#{list_to_use.join('|')})', 'gi') matchings
    ")
    .from("recipes")
    .where('ingredients::TEXT ~* ?', "(#{list_to_use.join('|')})")

    # Main query to order by relevance.
    select("
      id, name, image, ingredients, people_quantity, tags,
      array_length(array_agg(distinct matchings), 1) as matchings_length
    ")
    .from(sub_query, :sub_query)
    .group("id, name, image, ingredients, people_quantity, tags")
    .order("matchings_length DESC")
  end

  def self.useable_list(list_of_ingredients)
    list_of_ingredients
      .split(/\W/)
      .map { |ing| ing.presence && ing.singularize(:fr) }
      .compact
  end
end
