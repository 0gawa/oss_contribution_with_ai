module Orders
  class IdempotencyChecker
    def initialize(idempotency_key)
      @idempotency_key = idempotency_key
    end

    def duplicate_exists?
      @idempotency_key.present? && existing_order.present?
    end

    def existing_order
      @existing_order ||= Order.find_by(idempotency_key: @idempotency_key)
    end
  end
end
