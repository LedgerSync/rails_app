# frozen_string_literal: true

module Forms
  module Organizations
    class FindByExternalID
      include Formify::Form

      attr_accessor :external_id

      validates_presence_of :external_id,
                            :organization

      def save
        validate_or_fail
          .and_then { success(organization) }
      end

      private

      def organization
        @organization ||= Organization.find_by(external_id: external_id)
      end
    end
  end
end
