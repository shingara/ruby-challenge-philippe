require 'supplier_foo_api/client'

class FulfillOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    supplier = Supplier.find_by!(name: 'supplier_foo')

    Order.all.each do |order|
      reference = SupplierFooApi::Client.fulfill(product_name: order.product.name)
      order.update!(supplier: supplier, supplier_reference: reference)
    end
  end
end
