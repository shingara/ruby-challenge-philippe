require 'rails_helper'

RSpec.describe FulfillOrdersJob, type: :job do
  describe '#perform' do
    subject { job.perform }

    let(:job) { described_class.new }

    before do
      Order.create(customer_name: 'Orlando Bloom', product: Product.create( name: 'Fancy Headphones'))
      Order.create(customer_name: 'Dua Lipa', product: Product.create(name: 'Cool Smartphone'))
    end

    context 'when the supplier does not exist' do
      it 'raises an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Supplier")
      end

      it 'does not change any orders' do
        expect do
          subject rescue ActiveRecord::RecordNotFound
        end.not_to(change { Order.all.map(&:attributes) })
      end
    end

    context 'when the supplier exists' do
      let!(:supplier) { Supplier.create(name: 'supplier_foo') }

      it 'updates all orders with the supplier and the supplier reference' do
        expect { subject }.to change { Order.all.pluck(:supplier_id, :supplier_reference) }
          .from([[nil, nil], [nil, nil]])
          .to([[supplier.id, an_instance_of(String)], [supplier.id, an_instance_of(String)]])
      end
    end
  end
end
