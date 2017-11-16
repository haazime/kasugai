class Profile::ThemeController < ApplicationController

  def update
    ProfileService.update_theme(current_user, form_params[:theme])
    redirect_to edit_profile_url
  end

  private

    def form_params
      params.require(:form).permit(:theme)
    end
end
