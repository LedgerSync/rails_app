# frozen_string_literal: true

class OrganizationDecorator < Draper::Decorator # :nodoc:
  delegate_all

  def syncs_for_index
    syncs.created_at_desc.order(position: :desc).limit(10).decorate
  end

  def ledger_connected?
    @ledger_connected ||= ledgers.object.connected.any?
  end

  def ledgers(kind: nil)
    return object.ledgers.decorate if kind.nil?
    raise "#{kind} ledger is not registered." unless LedgerSync.adaptors.configs.key?(kind.to_sym)

    object.ledgers.where(
      kind: LedgerSync.adaptors.send(kind).root_key
    ).decorate
  end
end
