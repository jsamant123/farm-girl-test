require 'factory_bot_rails'

product_names = ['Burlap Bouquet', 'Peonies', 'The Minimalist', 'Jawbreaker', 'Reset Button']

product_names.each do |product_name|
  FactoryBot.create(:product, name: product_name)
end

distribution_center_names = ['Sun Valley', 'Green Valley', 'Agrogana']

distribution_center_names.each do |distribution_center_name|
  FactoryBot.create(:distribution_center, name: distribution_center_name)
end

FactoryBot.create(:fulfillment_center, name: 'Watsonville')

product = Product.find_by_name('Peonies')
distribution_center = DistributionCenter.find_by_name('Sun Valley')
FactoryBot.create(:distribution_center_product, product_id: product.id, distribution_center_id: distribution_center.id)

product = Product.find_by_name('Jawbreaker')
distribution_center = DistributionCenter.find_by_name('Green Valley')
FactoryBot.create(:distribution_center_product, product_id: product.id, distribution_center_id: distribution_center.id)

distribution_center = DistributionCenter.find_by_name('Agrogana')
FactoryBot.create(:distribution_center_product, product_id: product.id, distribution_center_id: distribution_center.id)

product = Product.find_by_name('The Minimalist')
FactoryBot.create(:distribution_center_product, product_id: product.id, distribution_center_id: distribution_center.id)
