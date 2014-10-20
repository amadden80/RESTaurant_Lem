class Order < ActiveRecord:: Base
  belongs_to :food
  belongs_to :party

  before_create :ensure_party_open

  class ClosedPartyFoodError < StandardError
  end

  private

  def ensure_party_open
    raise ClosedPartyFoodError if self.party.is_paid
  end

end
