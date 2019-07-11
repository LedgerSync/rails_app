class UserDecorator < Draper::Decorator # :nodoc:
  delegate_all

  def todos
    @todos ||= ledger_resources.todo.decorate
  end
end
