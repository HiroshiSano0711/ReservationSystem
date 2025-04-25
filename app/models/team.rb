class Team < ApplicationRecord
  # 変更した場合は、routes.rbでconstraintsを正規表現で指定しているのでそちらも書き換えること
  PERMALINK_REGEX = /\A[a-z0-9]+(?:-[a-z0-9]+)+\z/

  has_one :team_business_setting, dependent: :destroy
  has_one_attached :image, dependent: :purge_later
  has_one :admin_staff, -> { where(role: :admin_staff) }, class_name: "Staff"
  has_many :reservations, dependent: :destroy
  has_many :staffs, dependent: :destroy
  has_many :service_menus, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :permalink,
    presence: true,
    uniqueness: true,
    format: {
      with: PERMALINK_REGEX,
      message: "は英小文字・数字とハイフンで構成し、ハイフンで区切られている必要があります（連続ハイフン不可）"
    },
    length: { minimum: 5, maximum: 32 }
end
