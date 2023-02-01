class Reservation < ApplicationRecord

  # this does not make sense in real world application
  # but it is just for example based on the homework spec
  has_one :guest

  has_many :reservation_status_events
  has_one :active_status, class_name: "ReservationStatusEvent", foreign_key: :active_status_event_id

  validates :code, presence: true, uniqueness: true
  
end