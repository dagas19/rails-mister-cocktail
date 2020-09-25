class Cocktail < ApplicationRecord
  has_many :doses, dependent: :destroy
  has_many :ingredients, through: :doses
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  scope :by_name_or_ingredient, ->(name) {
    ingredient = Ingredient.find_by_name(name)
    return where("name Like '%#{name}'") unless ingredient
    eager_load(:doses).merge(Dose.where(ingredient_id: ingredient.id))
  }
end
