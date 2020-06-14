require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "scope for_meal" do
    appetizer_scope = Recipe.for_meal("Entrée")
    main_dish_scope = Recipe.for_meal("Plat principal")
    dessert_scope = Recipe.for_meal("Dessert")

    assert_includes appetizer_scope, recipes(:empanadas)
    assert_not_includes appetizer_scope, recipes(:quiche)
    assert_not_includes appetizer_scope, recipes(:nutella)

    assert_includes main_dish_scope, recipes(:quiche)
    assert_not_includes main_dish_scope, recipes(:empanadas)
    assert_not_includes main_dish_scope, recipes(:nutella)

    assert_includes dessert_scope, recipes(:nutella)
    assert_not_includes dessert_scope, recipes(:quiche)
    assert_not_includes dessert_scope, recipes(:empanadas)
  end

  test "scope for_people" do
    recipe_scope = Recipe.for_people(10)

    assert_includes recipe_scope, recipes(:empanadas)
    assert_includes recipe_scope, recipes(:nutella)
    assert_not_includes recipe_scope, recipes(:quiche)
  end

  test "#with_ingredients" do
    recipe_scope = Recipe.with_ingredients(Recipe.all, "lait, Oeufs")

    assert_includes recipe_scope, recipes(:quiche)
    assert_includes recipe_scope, recipes(:nutella)
    assert_not_includes recipe_scope, recipes(:empanadas)
  end
end
