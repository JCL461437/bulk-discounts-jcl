class BulkDiscountsController< ApplicationController

  before_action :set_merchant

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
    # @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant), notice: 'Bulk discount was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant), notice: 'Bulk discount was successfully deleted.'
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end

end
