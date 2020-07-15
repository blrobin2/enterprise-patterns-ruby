# frozen_string_literal: true

class KeyGenerator
  def initiaize(connection, key_name, increment_by)
    @connection = connection
    @key_name = key_name
    @increment_by = increment_by
    @next_id = @max_id = 0
    @mutex = Mutex.new
    # SQLite autocommit is off by default in a transaction
  end

  def next_key
    @mutex.synchronize do
      if (@next_id == @max_id)
        reserve_ids
      end
      next_id++
    end
  end

  private

  def reserve_ids
    new_next_id = @connection.get_first_value('SELECT next_id FROM keys WHERE name = ? FOR UPDATE', [ @key_name ])
    new_max_id = new_next_id + @increment_by
    @connection.execute('UPDATE keys SET next_id = ? WHERE name = ?', [ new_max_id, @key_name ])
    @next_id = new_next_id
    @max_id = new_max_id
  rescue SQLite3::SQLException => e
    raise Exception("Unable to generate ids", e)
  end
end