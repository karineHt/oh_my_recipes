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

  def self.with_ingredients(scope, ingredients)
    ingredients
      .split(/[\s|\.,\/\\]/)
      .map do |ing|
        scope = scope.where('ingredients::TEXT ilike ?', "%#{ing.singularize}%")
      end

    scope
  end
end
