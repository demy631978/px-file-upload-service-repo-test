class ErrorSerializer
  def self.serialize(object)
    {
      errors: object.errors.to_hash
    }
  end
end