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
      t.decimal :security_price, precision: 10, scale: 2
      t.decimal :total_price, precision: 10, scale: 2
      t.decimal :payout_price, precision: 10, scale: 2
      t.integer :guest_id
      t.integer :active_status_event_id
      t.string :currency
      t.timestamps
    end

    # this will log all status event changes
    create_table :reservation_status_events do |t|
      t.string :status
      t.text :remarks
      t.timestamps
    end

    create_table :guests do |t|
      t.string :first_name
      t.string :localized_description
      t.string :last_name
      t.string :phone_numbers, array: true, default: []
      t.string :email
      t.timestamps
    end

    add_index(:reservations, :active_status_event_id)
    add_index(:reservations, :guest_id)

    create_table :reservation_status_settings do |t|
      t.string :name
      t.datetime :deleted_at
      t.timestamps
    end

  end
end
