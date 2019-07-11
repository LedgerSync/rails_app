# frozen_string_literal: true

module Forms
  module Syncs
    class UpsertResources
      include Formify::Form

      attr_accessor :sync

      validates_presence_of :sync

      validate :validate_references

      initialize_with :sync

      def save
        with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { upsert_resources }
            .and_then { success(sync) }
        end
      end

      private

      delegate  :account,
                :references,
                :resources,
                to: :sync

      delegate  :ledgers,
                to: :account

      def upsert_resources
        references.inject(success) do |type_result, (resource_type, type_references)|
          type_result.and_then do
            type_references.inject(success) do |reference_result, (resource_external_id, reference)|
              reference_result.and_then do
                result = Forms::Resources::Upsert.new(
                  account: account,
                  external_id: resource_external_id,
                  type: resource_type
                ).save

                result = result.and_then do |resource|
                  Forms::SyncResources::Upsert.new(
                    data: reference['data'],
                    resource: resource,
                    sync: sync
                  ).save
                end

                result.and_then do |sync_resource|
                  sync.sync_resources << sync_resource
                  success(sync_resource)
                end
              end
            end
          end
        end

        success(sync)
      end

      def validate_references
        return if references.present?

        raise "References must be present for sync: #{sync.id}"
      end
    end
  end
end
