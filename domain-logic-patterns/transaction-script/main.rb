require 'sqlite3'
require_relative 'gateway'
require_relative 'recognition_service'

if __FILE__ == $PROGRAM_NAME
  DBNAME = 'revenue.sqlite'
  gateway = Gateway.new(SQLite3::Database.open(DBNAME))
  recognition_service = RecognitionService.new(gateway)

  CONTRACT_NUMBER = '123456789'
  recognition_service.calculate_revenue_recognitions(CONTRACT_NUMBER)
  recognized_revenue = recognition_service.recognized_revenue(CONTRACT_NUMBER, Date.today)
end

