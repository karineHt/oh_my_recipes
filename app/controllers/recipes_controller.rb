# frozen_string_literal: true

class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all

    if search_params[:meal].in? Recipe::MEAL
      @recipes = @recipes.for_meal(search_params[:meal])
    end

    if search_params[:ingredients].present?
      @recipes = @recipes.with_matching_ingredients(search_params[:ingredients])
    end

    if search_params[:people_quantity].present?
      @recipes = @recipes.for_people(search_params[:people_quantity])
    end


    @count   = @recipes.length
    @recipes = @recipes.page(params[:page] || 1)
  end

  private

  def search_params
    params.fetch(:search, {}).permit(:ingredients, :people_quantity, :meal)
  end
end
