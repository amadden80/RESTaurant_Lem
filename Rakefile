require 'bundler'
Bundler.require

namespace :db do

  desc "Create RESTaurant database"
  task :create do
    puts '...Creating the "restaurant" database'
    conn = PG::Connection.open()
    conn.exec('CREATE DATABASE restaurant;')
    conn.close
  end

  desc "Drop RESTaurant database"
  task :drop do
    puts '...Dropping the "restaurant" database'
    conn = PG::Connection.open()
    res = conn.exec('DROP DATABASE IF EXISTS restaurant;')
    conn.close
  end

  desc "Migrate table for RESTaurant"
  task :migrate do
    puts '...Creating the "parties" table'
    puts '...Creating the "foods" table'
    puts '...Creating the "orders" table'
    conn = PG::Connection.open(dbname: 'restaurant')
    conn.exec("CREATE TABLE parties (id SERIAL PRIMARY KEY, table_number INTEGER, num_guests INTEGER, is_paid BOOLEAN, is_satisified BOOLEAN);")
    conn.exec("CREATE TABLE foods (id SERIAL PRIMARY KEY, name VARCHAR(255), cuisine VARCHAR(255), cents INTEGER);")
    conn.exec("CREATE TABLE orders (id SERIAL PRIMARY KEY, food_id INTEGER, party_id INTEGER, is_free BOOLEAN, timestamp TIMESTAMP);")
    conn.close
  end

  desc "drop, create, and migrate RESTaurant database"
  task :reset do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  desc "create junk data for development"
  task :junk_data do

    ActiveRecord::Base.establish_connection({
      adapter: 'postgresql',
      database: 'restaurant'
    })

    require_relative 'models/food'
    require_relative 'models/party'
    require_relative 'models/order'

    Food.create({name: 'Mac & Cheese', cuisine: "Home", cents: 1400})
    Food.create({name: 'Steak', cuisine: "Meat", cents: 4000})
    Food.create({name: 'Kale Salad', cuisine: "Greens", cents: 3500})
    Food.create({name: 'Chicken Noodle Soup', cuisine: "Home", cents:1500})
    Food.create({name: 'Old Fashioned', cuisine: "Drink", cents:750})
    Food.create({name: 'Fizzy Water', cuisine: "Drink", cents:350})

    Party.create({table_number: 4,  num_guests: 3})
    Party.create({table_number: 9,  num_guests: 2})
    Party.create({table_number: 12, num_guests: 4})
    Party.create({table_number: 13, num_guests: 7})
    Party.create({table_number: 6,  num_guests: 2})
    Party.create({table_number: 11, num_guests: 3})
    Party.create({table_number: 18, num_guests: 1})

    parties = Party.all
    foods = Food.all

    parties.each do |party|
      party.num_guests.times do
        Order.create({party: party, food: foods.sample}) if [true, false].sample
      end
    end

  end

end


namespace :receipts do
  desc "delete all in public/receipts"
  task :delete do
    `rm -r public/receipts`
    `mkdir public/receipts`
  end
end
