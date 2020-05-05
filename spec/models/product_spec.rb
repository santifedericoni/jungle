require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do

    it 'should be able to create and save a new product' do
      cat = Category.create!
      product = Product.new(name: 'test', price: 80, quantity: 2, category: cat)
      expect(product).to be_valid
    end

    it 'should require a product to have a name' do
      cat = Category.create!
      product = Product.new(price: 80, quantity: 2, category: cat)
      expect(product).not_to be_valid
    end

    it 'should require a product to have a price' do
      cat = Category.create!
      product = Product.new(name: 'test', quantity: 2, category: cat)
      expect(product).not_to be_valid
    end

    it 'should require a product to have a quantity' do
      cat = Category.create!
      product = Product.new(name: 'test', price: 80, category: cat)
      expect(product).not_to be_valid
    end

    it 'should require a product to have a category' do
      product = Product.new(name: 'test', price: 80, quantity: 2)
      expect(product).not_to be_valid
    end

  end
end