module Billing
  class JobDecorator < ApplicationDecorator
    CHARGE_RATE = 0.001

    def charge
      object.duration * CHARGE_RATE
    end
  end
end
