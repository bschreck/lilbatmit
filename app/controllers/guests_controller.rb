class GuestsController < ApplicationController
  def index
    @guest = Guest.new
  end

  def rsvp
    student = rsvp_params[:student]
    email = rsvp_params[:email]
    if email != "" and student != ""
      exists = Guest.where(email: email).first
      if exists
        flash.alert = "Email exists"
        redirect_to action: :index, guest: @new_guest
      else
        @new_guest = Guest.new(rsvp_params)
        if @new_guest.save
          render :show
        else
          flash.now[:error] = "Error saving rsvp"
          redirect_to action: :index, guest: @new_guest
        end
      end
    else
      flash.alert = "Student and Email are required fields."
      redirect_to action: :index, guest: @new_guest
    end

  end

  def over
  end


  private
  def rsvp_params
    puts params
    params.require(:guest).permit(:student, :email, :first_name, :last_name)
  end
end
