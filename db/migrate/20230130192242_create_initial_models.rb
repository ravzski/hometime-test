class CreateInitialModels < ActiveRecord::Migration[7.0]
  def change

    create_table :reservations do |t|
      t.string :code
      t.datetime :start_date
      t.datetime :end_date
      t.integer :nights
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.integer :guests
      t.decimal :security_price, precision: 10, scale: 2
      t.decimal :total_price, precision: 10, scale: 2
      t.decimal :payout_price, precision: 10, scale: 2
      t.integer :active_status_event_id
      t.string :currency
      t.timestamps
    end

    # this will log all status event changes
    create_table :reservation_status_events do |t|
      t.string :status
      t.text :remarks
      t.integer :reservation_id
      t.timestamps
    end

    create_table :guests do |t|
      t.string :first_name
      t.string :localized_description
      t.string :last_name
      t.string :phone_numbers, array: true, default: []
      t.string :email
      t.integer :reservation_id
      t.timestamps
    end

    add_index(:reservations, :active_status_event_id)
    add_index(:reservation_status_events, :reservation_id)
    add_index(:guests, :reservation_id, unique: true)
    add_index(:guests, :email, unique: true)
    add_index(:reservations, :code, unique: true)

    create_table :reservation_status_settings do |t|
      t.string :name
      t.datetime :deleted_at
      t.timestamps
    end

  end
end
