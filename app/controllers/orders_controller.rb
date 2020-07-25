class OrdersController < ApplicationController
  before_action :find_order, only: %i[show]

  def index
    date = Date.current
    @orders = Order.in_between_dates(date.beginning_of_day, date.end_of_day)
    @total_order_items, @average_quantity_sold = @orders.joins(:order_items)
                                                        .pluck("sum(order_items.quantity) as total_order_items,
                                                                avg(order_items.quantity) as average_quantity_sold").first
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = t('order.create.success')
      redirect_to orders_path
    else
      flash[:danger] = t('order.create.error')
      redirect_to new_order_path
    end
  end

  def show; end

  def mark_fulfilled; end

  private

  def find_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def order_params
    params.require(:order).permit(order_items_attributes: %i[product_id quantity _destroy])
  end
end
