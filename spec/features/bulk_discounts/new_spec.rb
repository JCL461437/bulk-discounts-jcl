require "rails_helper"

RSpec.describe "bulk discounts new page" do
  before :each do
  end

  it "sees a form with forms that can be filled and a button to create the new discount" do
    merchant = Merchant.create!(name: "A New Merchant")

    visit new_merchant_bulk_discount_path(merchant)

    expect(page).to have_css('form')
    
    expect(page).to have_field('Percentage discount')
    fill_in "Percentage discount", with: 10

    expect(page).to have_field('Quantity threshold')
    fill_in "Quantity threshold", with: 5

    click_button "Create Bulk Discount"

    expect(page).to have_current_path(merchant_bulk_discounts_path(merchant))

    expect(page).to have_content('Bulk discount was successfully created.')
  
    expect(page).to have_content("Percentage Discount: 10%")
    expect(page).to have_content("Quantity Threshold: 5")

  end

end
