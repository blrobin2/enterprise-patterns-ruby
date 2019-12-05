require_relative 'application_service'

class RecognitionService < ApplicationService

  def calculate_revenue_recognitions(contract_number)
    contract = Contract.read_for_update(contract_number)
    contract.calculate_recognitions
    get_email_gateway.send_email_message(
      contract.get_administrator_email_address,
      "RE Contract ##{contract_number}",
      "#{contract} has has revenue recognitions calculated."
    )
    get_integration_gateway.publish_revenue_recognition_calculation(contract)
  end

  def recognized_revenue(contract_number, as_of)
    Contract.read(contract_number).recognized_revenue(as_of)
  end
end