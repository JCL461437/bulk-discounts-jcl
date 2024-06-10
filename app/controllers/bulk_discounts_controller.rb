class BulkDiscountsController< ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
    # @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
end
