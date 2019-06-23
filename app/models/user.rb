class User < ApplicationRecord
  has_many :articles, dependent: :destroy # Si un utilisateur est supprimé par l'admin , tous ses articles le seront également
  before_save { self.email = email.downcase } # avant la sauvegarde dans la BD, on met l'email en minuscule
  validates :username, presence: true,
  uniqueness: {case_sensitive: false},
  length: {minimum: 3, maximum: 25}

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true,
  length: {maximum: 105},
  uniqueness: {case_sensitive: false},
  format: {with: VALID_EMAIL_REGEX}

  has_secure_password
end
