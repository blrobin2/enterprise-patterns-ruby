# frozen_string_literal: true

# A way of tracking whether an object has loaded or not
# Kind of overkill, just here for demonstrating deferred loading
class DomainObjectEl
  LOADING = 0
  ACTIVE = 1

  def initialize
    @state = LOADING
  end

  def be_active
    @state = ACTIVE
  end

  def assert_state_is_loading
    raise 'Invalid state' unless @state == LOADING
  end
end
