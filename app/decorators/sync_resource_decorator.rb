class SyncResourceDecorator < ApplicationDecorator # :nodoc:
  decorates_associations :resource, :sync

  def tab_title
    t('sync_resources.tab_title', date: l(created_at.to_date, format: :date))
  end
end
