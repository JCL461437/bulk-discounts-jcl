require "csv"

namespace :csv_load do
  task :customers => :environment do
    CSV.foreach("db/data/customers.csv", headers: true) do |row|
      Customer.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("customers")
    puts "Customers imported."
  end

  task :merchants => :environment do
    CSV.foreach("db/data/merchants.csv", headers: true) do |row|
      Merchant.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("merchants")
    puts "Merchants imported."
  end

  task :items => :environment do
    CSV.foreach("db/data/items.csv", headers: true) do |row|
      Item.create!(
        id: row["id"], 
        name: row["name"], 
        description: row["description"], 
        unit_price: row["unit_price"].to_f / 100, 
        created_at: row["created_at"], 
        updated_at: row["updated_at"], 
        merchant_id: row["merchant_id"], 
        status: 1
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("items")
    puts "Items imported."
  end

  task :invoices => :environment do
    CSV.foreach("db/data/invoices.csv", headers: true) do |row|
      status = case row["status"]
               when "cancelled" then 0
               when "in progress" then 1
               when "completed" then 2
               end
      Invoice.create!(
        id: row[0],
        customer_id: row[1],
        status: status,
        created_at: row[4],
        updated_at: row[5]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("invoices")
    puts "Invoices imported."
  end

  task :transactions => :environment do
    CSV.foreach("db/data/transactions.csv", headers: true) do |row|
      result = case row["result"]
               when "failed" then 0
               when "success" then 1
               end
      Transaction.create!(
        id: row[0],
        invoice_id: row[1],
        credit_card_number: row[2],
        credit_card_expiration_date: row[3],
        result: result,
        created_at: row[5],
        updated_at: row[6]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("transactions")
    puts "Transactions imported."
  end

  task :invoice_items => :environment do
    CSV.foreach("db/data/invoice_items.csv", headers: true) do |row|
      status = case row["status"]
               when "pending" then 0
               when "packaged" then 1
               when "shipped" then 2
               end
      InvoiceItem.create!(
        id: row[0],
        item_id: row[1],
        invoice_id: row[2],
        quantity: row[3],
        unit_price: row[4],
        status: status,
        created_at: row[6],
        updated_at: row[7]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("invoice_items")
    puts "InvoiceItems imported."
  end

  task :bulk_discounts => :environment do
    CSV.foreach("db/data/bulk_discounts.csv", headers: true) do |row|
      BulkDiscount.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("bulk_discounts")
    puts "BulkDiscounts imported."
  end

  task :all => :environment do
    Rake::Task["csv_load:customers"].invoke
    Rake::Task["csv_load:merchants"].invoke
    Rake::Task["csv_load:items"].invoke
    Rake::Task["csv_load:invoices"].invoke
    Rake::Task["csv_load:transactions"].invoke
    Rake::Task["csv_load:invoice_items"].invoke
    Rake::Task["csv_load:bulk_discounts"].invoke
    puts "All data imported."
  end
end