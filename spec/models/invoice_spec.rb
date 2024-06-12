require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    @merchant = Merchant.create(name: "Test Merchant")
    @item1 = Item.create(name: "I don't know", merchant: @merchant, unit_price: 10)
    @item2 = Item.create(name: "The Guy", merchant: @merchant, unit_price: 15)
    @discount1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: @merchant.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant.id)
    @discount3 = BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 8, merchant_id: @merchant.id)
  end

  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions }
  end

  describe "instance methods" do
    it "calculates total revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end
  end

  describe "#total_discounted_revenue" do
    it "calculates total discounted revenue correctly" do
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice = Invoice.create!(customer: customer_1, status: 2)

      item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      item2 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)

      invoice_item1 = InvoiceItem.create!(item: item1, quantity: 12, unit_price: 10, invoice: invoice)
      invoice_item2 = InvoiceItem.create!(item: item2, quantity: 8, unit_price: 15, invoice: invoice)

      total_revenue = invoice.total_revenue
      total_discounted_revenue = invoice.total_discounted_revenue

      expected_discounted_revenue = total_revenue - ((12 * 10 * (20 / 100.0)) + (8 * 15 * (15 / 100.0)))

      expect(total_discounted_revenue).to eq(expected_discounted_revenue)
    end

    it "does not return negative total discounted revenue" do
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice = Invoice.create!(customer: customer_1, status: 2)

      invoice_item1 = InvoiceItem.create!(item: @item1, quantity: 5, unit_price: 10, invoice: invoice)
      invoice_item2 = InvoiceItem.create!(item: @item2, quantity: 8, unit_price: 15, invoice: invoice)

      allow(invoice).to receive(:total_discount).and_return(invoice.total_revenue + 100) # Simulate a large discount

      expect(invoice.total_discounted_revenue).to eq(0)
    end
  end
end
