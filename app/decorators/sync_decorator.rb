class SyncDecorator < ApplicationDecorator
  decorates_association :ledgers

  def ledgers_not_connected
    @ledgers_not_connected ||= organization.ledgers.where.not(id: ledgers.object.select(:id)).decorate
  end

  def status_color
    case status.to_sym
    when :blocked
      :warning
    when :failed
      :danger
    when :succeeded
      :success
    else
      :secondary
    end
  end

  def title
    t('syncs.title', type: resource_type.titleize)
  end

  def todos
    @todos ||= ledger_resources.todo.decorate
  end
end
