class OrdersController < ApplicationController
  before_action :find_order, only: %i[show mark_fulfilled]
  before_action :validate_date, only: :index

  def index
    date = @parsed_date || Date.current
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

  def mark_fulfilled
    redirect_to orders_path, flash: { danger: t('order.already_fulfilled') } and return if @order.fulfilled?

    if @order.fulfilled!
      flash[:success] = t('order.fulfilled.success')
      redirect_to orders_path
    else
      flash[:danger] = t('order.fulfilled.error')
      render :show
    end
  end

  private

  def find_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def order_params
    params.require(:order).permit(order_items_attributes: %i[product_id quantity _destroy])
  end

  def validate_date
    return if params[:date].blank?

    @parsed_date = Date.strptime(params[:date], '%m/%d/%Y').to_datetime rescue nil
    unless @parsed_date
      @message = t('errors.invalid_date')
      respond_to { |format| format.js { render "index" } }
    end
  end
end
