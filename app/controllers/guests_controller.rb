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
          puts add_to_mailing_list
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
    params.require(:guest).permit(:student, :email, :first_name, :last_name, :zip)
  end

  def add_to_mailing_list
    email = rsvp_params["email"]
    first = nil
    last = nil
    if rsvp_params.has_key?("first_name")
      first = rsvp_params["first_name"]
    end
    if rsvp_params.has_key?("last_name")
      last = rsvp_params["last_name"]
    end
    if rsvp_params.has_key?("zip")
      zip = rsvp_params["zip"]
    end

    gb = Lilbatmit::Application::GB
    lilb_list_id = "fa3d22a183"
    json_response = gb.lists.subscribe({:id => lilb_list_id, :email => {:email => email}, :merge_vars => {:FNAME => first, :LNAME => last, :ZIP => zip}, :double_optin => false})

    if json_response.has_key?("email") and json_response["email"] == rsvp_params["email"] and
        json_response.has_key?("euid") and json_response.has_key?("leid")
      return {status: "subscribed"}
    elsif json_response.has_key?("code") and json_response["code"]==214 and
        json_response.has_key?("status") and json_response["status"]=="error"
      return {status: "error", reason: "old_email"}
    else
      return {status: "error", reason: "unknown"}
    end
  end
end
