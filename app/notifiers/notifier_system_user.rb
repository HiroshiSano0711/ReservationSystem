class NotifierSystemUser
  attr_reader :id, :email, :name

  def initialize
    @id = nil
    @email = "no-reply@example.com"
    @name = "SystemUser"
  end

  def to_s
    name
  end
end
