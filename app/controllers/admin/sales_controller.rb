class Admin::SalesController < ApplicationController
  user = ENV['ADMIN_USER']
  pass = ENV['ADMIN_PASS']
  http_basic_authenticate_with name: user, password: pass

  def index
    @sales = Sale.all.order(:starts_on, :ends_on)
  end

  def new
    @sale = Sale.new
  end

  def create
    @sale = Sale.new(sale_params)

    if @sale.save
      redirect_to [:admin, :sales], notice: 'Sale created!'
    else
      render :new
    end
  end

  def destroy
    @sale = Sale.find params[:id]
    @sale.destroy
    redirect_to [:admin, :sales], notice: 'Sale deleted!'
  end

  private
    def sale_params
      params.require(:sale).permit(
        :name,
        :starts_on,
        :ends_on,
        :percent_off
      )
    end

end