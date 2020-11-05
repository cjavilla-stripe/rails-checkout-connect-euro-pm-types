# == Schema Information
#
# Table name: stores
#
#  id                :bigint           not null, primary key
#  name              :string
#  country           :string
#  stripe_account_id :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  enabled_pm_types  :string           is an Array
#
class Store < ApplicationRecord
  def stripe_account
    @stripe_account ||= Stripe::Account.retrieve(stripe_account_id)
  end

  def pm_types
    supported_pm_types & enabled_pm_types
  end

  def supported_pm_types
    capability_to_pm_type = {
      bancontact_payments: 'bancontact',
      card_payments: 'card',
      eps_payments: 'eps',
      giropay_payments: 'giropay',
      ideal_payments: 'ideal',
      p24_payments: 'p24',
      sepa_debit_payments: 'sepa_debit',
      sofort_payments: 'sofort',
    }
    stripe_account
      .capabilities
      .select {|c, active| active && capability_to_pm_type.has_key?(c)}
      .map {|c, _| capability_to_pm_type[c]}
  end
end
