module ApplicationHelper
  include Pagy::Frontend
  def format_amount(amount)
    ActionController::Base.helpers.number_to_currency(amount.to_f,
                                                      unit: "PLN",
                                                      strip_insignificant_zeros: true,
                                                      delimiter: ' ',
                                                      precision: 2,
                                                      format: '%n %u')
  end

  def format_percentage(percentage)

  end

end
