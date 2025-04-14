class NotifierSystemUser
  include ActiveModel::Model

  attr_reader :id

  def id
    nil
  end

  def name
    "SystemUser"
  end

  def to_s
    name
  end

  def persisted?
    false
  end
end
