class User < ApplicationRecord
  # relations
  has_many :subscriptions
  has_many :subscribed_courses, through: :subscriptions, source: :course

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def as_json(*)
    super(except: :id)
  end

  # subscribe the course when it is not subscribed
  # otherwise unsubscribe the course
  def subscribe(crn)
    course = Course.find_by(crn: crn, quarter: Rails.application.credentials.quarter)

    raise ActiveRecord::RecordNotFound, 'Crn not found!' unless course.present?

    begin
      subscribed_courses << course
    rescue ActiveRecord::RecordNotUnique
      subscribed_courses.destroy course
    end
  end

  def subscribed_courses_crns
    subscribed_courses
      .where(quarter: Rails.application.credentials.quarter)
      .pluck(:crn)
  end
end
