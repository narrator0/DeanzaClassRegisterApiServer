class User < ApplicationRecord
  # relations
  has_many :subscribtions
  has_many :subscribed_courses, through: :subscribtions, source: :course

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def as_json(*)
    super(except: :id)
  end
end
