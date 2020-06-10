# frozen_string_literal: true

class Recipe < ApplicationRecord
  MEAL = ["Plat principal", "Dessert", "Entrée"].freeze

  scope :for_meal, -> (meal) { where("tags @> ARRAY[?]", meal) }
  scope :for_people, -> (number) { where("people_quantity >= ?", number) }

  def self.with_ingredients(scope, ingredients)
    ingredients
      .split(/[\s|\.,\/\\]/)
      .map do |ing|
        scope = scope.where("ingredients::TEXT ilike ?", "%#{ing.singularize}%")
      end

    scope
  end
end
