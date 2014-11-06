class GuestsController < ApplicationController
  def index
    @guest = Guest.new
  end

  def rsvp
    student = rsvp_params[:student]
    email = rsvp_params[:email]
    if email and student
      exists = Guest.where(email: email).first
      if exists
        flash.alert = "Email exists"
        redirect_to action: :index, guest: @new_guest
      else
        @new_guest = Guest.new(student: student, email: email)
        if @new_guest.save
          render :show
        else
          flash.now[:error] = "Error saving rsvp"
          redirect_to action: :index, guest: @new_guest
        end
      end
    else
      redirect_to action: :index, guest: @new_guest
    end



  end


  private
  def rsvp_params
    puts params
    params.require(:guest).permit(:student, :email)
  end
end
