require "rails_helper"

RSpec.describe "bulk_discounts show view" do

  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @discount1 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 5, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 5, quantity_threshold: 2, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 4, merchant_id: @merchant1.id)
  end
  
  it "shows a link to edit a discount" do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    expect(page).to have_content("Quantity Threshold: #{@discount1.quantity_threshold}")
    expect(page).to have_content("Percentage Discount: #{@discount1.percentage_discount.to_i} %")

    expect(page).to have_link("Edit This Discount")

    click_link "Edit This Discount"
  end
end