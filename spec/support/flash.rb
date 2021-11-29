#-- encoding: UTF-8



def disable_flash_sweep
  controller.instance_eval { RSpec::Mocks.allow_message(flash, :sweep) }
end
