class LedgerResourceDecorator < ApplicationDecorator # :nodoc:
  decorates_associations :ledger, :resource

  delegate :adaptor, to: :ledger

  def assignment_title
    t('ledger_resources.assignment_title', ledger: ledger.name, type: resource.type)
  end

  def assignment_confirmation
    t(
      'ledger_resources.assignment_confirmation',
      ledger: ledger.name,
      type: resource.type
    )
  end

  def recent_syncs
    @recent_syncs ||= sync_resources.recent.decorate
  end

  def searcher?
    adaptor.searcher_for?(resource_type: resource.type)
  end

  def title
    t('todos.title', ledger: ledger.name, type: resource.type)
  end
end
