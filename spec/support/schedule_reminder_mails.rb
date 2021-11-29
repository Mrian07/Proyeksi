

##
# Calculates a slot in the user's local time that hits for scheduling reminder mail jobs
def hitting_reminder_slot_for(time_zone, current_utc_time = Time.current.getutc)
  current_utc_time.in_time_zone(ActiveSupport::TimeZone[time_zone]).strftime('%H:00:00+00:00')
end
