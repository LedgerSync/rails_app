class LedgerDecorator < Draper::Decorator # :nodoc:
  include Routable

  delegate_all

  def adaptor
    @adaptor ||= Util::AdaptorBuilder.new(ledger: object).adaptor
  end

  def name
    LedgerSync.adaptors.send(ledger.kind.to_sym).name
  end

  def show_path
    case kind.to_s
    when Util::QuickBooksOnline::KEY
      r.ledgers_quickbooks_online_path(self)
    when LedgerSync.adaptors.test.root_key.to_s
      raise NotImplementedError unless Rails.env.test?
      r.ledgers_test_path(self)
    else
      raise NotImplementedError
    end
  end
end
