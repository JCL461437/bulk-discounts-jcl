class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discount
    invoice_items.joins(item: { merchant: :bulk_discounts })
                 .where('bulk_discounts.quantity_threshold <= invoice_items.quantity')
                 .group('invoice_items.id')
                 .sum { |invoice_item| invoice_item.discount_amount }
  end

  def total_discounted_revenue
    total_discounted_revenue = total_revenue - total_discount
    total_discounted_revenue.negative? ? 0 : total_discounted_revenue
  end
end
