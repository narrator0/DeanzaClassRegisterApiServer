class User < ApplicationRecord
  # relations
  has_many :notify_subscriptions
  has_many :subscribe_courses, through: :notify_subscriptions, source: :course

  has_many :likes
  has_many :like_courses, through: :likes, source: :course

  has_many :calendars
  has_many :calendar_courses, through: :calendars, source: :course

  has_many :notifications
  has_many :course_status_update_notifications

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def as_json(*)
    super(except: :id)
  end

  # subscribe the course when it is not subscribed
  # otherwise unsubscribe the course
  # todo: raise error if type in not 'subscribe', 'like', or 'calendar'
  def subscribe(crn, type = 'subscribe')
    course = Course.find_by(crn: crn, quarter: Rails.application.credentials.quarter)

    raise ActiveRecord::RecordNotFound, 'Crn not found!' unless course.present?
    raise ArgumentError.new('type must be provided!') unless type.present?

    unless self.send("#{type}_courses").include?(course)
      self.send("#{type}_courses") << course
    else
      self.send("#{type}_courses").destroy course
    end
  end

  def subscribed_courses_crns(type = 'subscribe')
    raise ArgumentError.new('type must be provided!') unless type.present?

    self.send("#{type}_courses")
      .where(quarter: Rails.application.credentials.quarter)
      .pluck(:crn)
  end
end
