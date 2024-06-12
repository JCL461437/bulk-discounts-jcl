require "rails_helper"

RSpec.describe "bulk discounts edit page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @discount1 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 5, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 5, quantity_threshold: 2, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 4, merchant_id: @merchant1.id)
  end

  it "sees a form filled in with the discounts attributes" do
    visit edit_merchant_bulk_discount_path(@merchant1, @discount1)

    expect(find_field("Quantity threshold").value).to eq("#{@discount1.quantity_threshold}")
    expect(find_field("Percentage discount").value).to eq("#{@discount1.percentage_discount}")


    expect(find_field("Quantity threshold").value).to_not eq(@discount1.quantity_threshold)
  end

  it "can fill in form, click submit, and redirect to that bulk discount's show page and see updated info and flash message" do
    visit edit_merchant_bulk_discount_path(@merchant1, @discount1)

    fill_in "Quantity threshold", with: "10"
    fill_in "Percentage discount", with: "30"

    click_button "Update Discount"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    # save_and_open_page
    expect(page).to have_content("Quantity Threshold: 10")
    expect(page).to have_content("Percentage Discount: 30 %")

    expect(page).to have_content("Bulk discount was successfully updated.")
  end
end