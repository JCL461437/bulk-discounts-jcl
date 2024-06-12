require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  before(:each) do
    @merchant = Merchant.create(name: "Test Merchant")
    @item = Item.create(name: "Test Item", merchant: @merchant)
    @discount1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: @merchant.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant.id)
  end

  describe "validations" do
    it { should validate_presence_of :percentage_discount }
    it { should validate_presence_of :quantity_threshold }
  end
  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "#apply_discount" do
    it "applies the highest percentage discount available" do
      invoice_item = InvoiceItem.new(item: @item, quantity: 12, unit_price: 10)

      discount_amount = invoice_item.discount_amount

      expect(discount_amount).to eq(12 * 10 * (20 / 100.0))
    end

    it "does not apply any discount if quantity does not meet threshold" do
      invoice_item = InvoiceItem.new(item: @item, quantity: 3, unit_price: 10)

      discount_amount = invoice_item.discount_amount

      expect(discount_amount).to eq(0)
    end
  end
end

