class CreateIdempotencyKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :idempotency_keys do |t|
      t.string :key, index: true
      t.jsonb :response_body
      t.integer :response_status
      t.string :request_id, index: true

      t.timestamps
    end
  end
end
