require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:fulfillment_center) { FactoryBot.create(:fulfillment_center) }
  let(:order) { FactoryBot.create(:order, fulfiller: fulfillment_center) }
  let(:order_item) { FactoryBot.create(:order_item, order: order) }
  let(:product) { FactoryBot.create(:product) }

  describe 'GET #index' do
    it 'should take user to index page' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should render orders as per date' do
      fulfiller = FactoryBot.create(:fulfillment_center)
      order_item_today = FactoryBot.create(:order_item, order: order)
      order.reload
      order_yesterday = FactoryBot.create(:order, fulfiller: fulfiller, created_at: 1.day.ago)
      order_item_yesterday = FactoryBot.create(:order_item, created_at: 1.day.ago, order: order_yesterday)
      order_yesterday.reload

      get :index
      expect(assigns(:orders)).to eq([order])
      expect(assigns(:total_order_items)).to eq(order_item_today.quantity)
      expect(assigns(:average_quantity_sold)).to eq(order.order_items.sum(:quantity) / order.order_items.length)

      get :index, params: { date: 1.day.ago.strftime('%m/%d/%Y') }
      expect(assigns(:orders)).to eq([order_yesterday])
      expect(assigns(:total_order_items)).to eq(order_item_yesterday.quantity)
      expect(assigns(:average_quantity_sold)).to eq(order_yesterday.order_items.sum(:quantity) / order_yesterday.order_items.length)
    end

    it 'should display error for invalid date' do
      get :index, params: { date: I18n.t('test.order_id') }, xhr: true
      expect(assigns(:message)).to eq(I18n.t('errors.invalid_date'))
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #new' do
    it 'should take user to new order page' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'should take user to show order page' do
      get :show, params: { id: order }
      expect(response).to have_http_status(:success)
    end

    it 'should raises error if order not found' do
      get :show, params: { id: '0abc-1xyz' }
      expect(flash[:danger]).to eq(I18n.t('errors.not_found'))
    end
  end

  describe 'POST #mark_fulfilled' do
    it 'should change order status to fulfilled ' do
      order.not_fulfilled!
      post :mark_fulfilled, params: { order_id: order }
      order.reload
      expect(order.status).to eq I18n.t('test.order.fulfilled_status')
    end

    it 'should redirect if already fulfilled' do
      order.fulfilled!
      post :mark_fulfilled, params: { order_id: order }
      expect(flash[:danger]).to eq(I18n.t('order.already_fulfilled'))
      expect(response).to redirect_to orders_path
    end

    it 'should raises error if order not found' do
      post :mark_fulfilled, params: { order_id: '0abc-1xyz' }
      expect(flash[:danger]).to eq(I18n.t('errors.not_found'))
    end
  end

  describe 'POST #create' do
    it 'should create order with order items for valid params' do
      FactoryBot.create(:fulfillment_center)
      expect { post :create, params: params }.to change { Order.count }.by(1)
      order = Order.last

      expect(flash[:success]).to eq(I18n.t('order.create.success'))
      expect(order.product_names).to eq(product.name)

      expect(response).to have_http_status(:redirect)
    end

    it 'should not create order and order items for invalid params' do
      expect { post :create, params: { order: { order_attributes: { quantity: 1 } } } }.to change { Order.count }.by(0)

      expect(flash[:danger]).to_not be_nil
      expect(response).to redirect_to new_order_path
    end
  end

  def params
    {
      order: { order_items_attributes: [product_id: product.id, quantity: 2] }
    }
  end
end
