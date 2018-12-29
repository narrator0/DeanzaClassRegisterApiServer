class UserMailer < ApplicationMailer
  def notify_status_change(user, course, origin_status, current_status)
    @user = user
    @origin_status  = origin_status
    @current_status = current_status
    @course = course
    @lecture = @course.lectures.first

    mail(to: @user.email, subject: "Status of #{@course.course} has become \"#{@current_status}\"")
  end
end
