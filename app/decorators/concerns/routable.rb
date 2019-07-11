module Routable
  def r
    @r ||= Util::Router.new
  end
end