class OrdersController < ApplicationController

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

  def create; end

  def show; end

  def mark_fulfilled; end

end
