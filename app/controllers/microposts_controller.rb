class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # On failed micropost submission, the program breaks without this line
      # because the Home page expects an @feed_items variable
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # "request.referrer" just goes to the previous page
    redirect_to request.referrer || root_url
  end

  private

    # Content attribute only permitted to be changed through the web
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # Can only delete microposts if the correct user
    def correct_user
     @micropost = current_user.microposts.find_by(id: params[:id])
     redirect_to root_url if @micropost.nil?
    end

end
