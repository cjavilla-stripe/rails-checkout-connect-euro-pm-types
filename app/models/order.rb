# == Schema Information
#
# Table name: orders
#
#  id                         :bigint           not null, primary key
#  stripe_checkout_session_id :string
#  store_id                   :bigint           not null
#  status                     :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class Order < ApplicationRecord
  belongs_to :store
end
