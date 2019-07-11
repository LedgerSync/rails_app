class AddRequestBodyToIdempotencyKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :idempotency_keys, :request_body, :jsonb
  end
end
