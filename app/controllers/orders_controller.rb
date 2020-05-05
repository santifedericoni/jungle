class OrdersController < ApplicationController

  # before_filter :authorize

  def index
    @orders = Order.where(email: current_user.email)

  end

  def show
    @order = Order.find(params[:id])
    @line_items = @order.line_items.map {|item| { line_item:item, product:Product.find(item.product_id) } }
  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    active_sale = Sale.highest_active
    discount = ( active_sale && 1 - active_sale.percent_off / 100.00 ) || 1

    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]

      discount_price = product.price * discount
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: discount_price,
        total_price: discount_price * quantity
      )
    end
    order.save!
    order
  end

end