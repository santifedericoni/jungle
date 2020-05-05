module SalesHelper
  def active_sale
    Sale.highest_active
  end
end