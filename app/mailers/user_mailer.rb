class UserMailer < ApplicationMailer
  def notify_status_change(user, origin_status, course)
    @user = user
    @origin_status  = origin_status
    @course = course

    mail(to: @user.email, subject: "Status of #{@course.course} has become \"#{@course.status}\"")
  end
end
