class Food < ActiveRecord:: Base
  has_many :parties, :through => :orders
  has_many :orders

  validates :name, :cents, presence: true

  def to_s
    "#{self.name}: ($#{ self.cost_dollars })"
  end

  def cost_dollars
    self.cents.to_f / 100
  end
end
