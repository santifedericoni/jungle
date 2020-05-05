class Admin::DashboardController < ApplicationController
  user = ENV['ADMIN_USER']
  pass = ENV['ADMIN_PASS']
  http_basic_authenticate_with name: user, password: pass
  def show
    @product_count = Product.count()
    @category_count = Category.count()
    @order_count = Order.count()
    @order_revenue = Order.sum(:total_cents)
  end
end