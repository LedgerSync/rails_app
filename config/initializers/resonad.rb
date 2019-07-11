class Resonad
  class Success
    def raise_if_error
      self
    end
  end

  class Failure
    def raise_if_error
      raise error
    end
  end
end
