class GuestsController < ApplicationController
  def index
    if Guest.all.length >= 300
      redirect_to action: :over
    else
      @guest = Guest.new
    end
  end

  def rsvp
    student = rsvp_params[:student]
    email = rsvp_params[:email]
    if Guest.all.length >= 300
      redirect_to action: :over
    else
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
        flash.alert = "Please fill out all fields!"
        redirect_to action: :index, guest: @new_guest
      end
    end

  end

  def over
  end


  private
  def rsvp_params
    puts params
    params.require(:guest).permit(:student, :email)
  end
end
