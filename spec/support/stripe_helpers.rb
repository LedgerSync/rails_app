# frozen_string_literal: true

module StripeHelpers
  extend self

  def fill_stripe_elements(card: '4242424242424242', expiry: '1234', cvc: '123', postal: '12345')
    using_wait_time(10) {
      frame = find('#card-element > div > iframe')
      within_frame(frame) do
      card.to_s.chars.each do |piece|
        find_field('cardnumber').send_keys(piece)
      end

      find_field('exp-date').send_keys expiry
      find_field('cvc').send_keys cvc
      find_field('postal').send_keys postal
    end }
  end

  def stripify_user(user)
    user.update!(
      card: FactoryBot.create(:card, user: user),
      stripe_customer_id: stripe_good_customer_id
    )
  end

  # def stripe_bad_card_id
  #   'card_1CsgHUBrrF2ThRqvcuMQvMEn'
  # end

  def stripe_card_token
    'tok_visa'
  end

  def stripe_good_card_id
    'card_1EV7HHBgQbO8t6gYXjCrYQck'
  end

  def stripe_good_customer_id
    'cus_Ez5RFJpdNd4vG9'
  end
end
