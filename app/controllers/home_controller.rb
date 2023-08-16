class HomeController < ApplicationController
  def index
  end

  def services
  end

  def projects
  end

  def pricing
  end

  def contacts
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to root_path, notice: "Your message has been sent."
    else
      redirect_to root_path, notice: "Your message has not been sent."
    end
  end

  def abouat
  end

  def curriculum 
  end

  private 

  def contact_params
    params.permit(:name, :email, :message)
  end

end
