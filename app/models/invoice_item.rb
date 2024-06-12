class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discount_amount
    bulk_discount = item.merchant.bulk_discounts
                       .where('quantity_threshold <= ?', quantity)
                       .order(percentage_discount: :desc)
                       .first
    if bulk_discount
      (quantity * unit_price * (bulk_discount.percentage_discount / 100.0)).to_f
    else
      0
    end
  end
end
