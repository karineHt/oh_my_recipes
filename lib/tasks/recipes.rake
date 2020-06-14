# frozen_string_literal: true

# Tasks related to recipe model
namespace :recipes do
  desc 'Import recipes from a json file'
  task import: :environment do
    logger = Logger.new($stdout)
    logger.info('### Start ###')

    file = File.open('db/imports/recipes.json')
    file.each_line do |line|
      next if line.blank?

      line_data = JSON.parse(line)
      Recipe.create(
        image: line_data['image'],
        name: line_data['name'],
        people_quantity: line_data['people_quantity'],
        ingredients: line_data['ingredients'],
        tags: line_data['tags']
      )
    end

    logger.info('### End ###')
  end
end
