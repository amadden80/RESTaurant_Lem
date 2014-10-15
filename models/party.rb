class Party < ActiveRecord:: Base
  has_many :foods, :through => :orders
  has_many :orders

  def to_s
    "Table (#{self.table_number}): #{ self.num_guests } guests"
  end

  def is_open?
    !self.is_paid
  end

  def total_cents
    orders = self.orders.select {|order| !order.is_free }
    cents = orders.map {|order| order.food.cents }
    cents.inject(:+)
  end

  def total_dollars
    self.total_cents.to_f/100
  end

  def tip(percent)
    ((self.total_dollars.to_f * percent * 100).round).to_f/100
  end

end
