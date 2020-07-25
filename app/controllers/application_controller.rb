class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing do
    render_error(t('errors.no_items_select'))
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_error(t('errors.not_found'))
  end

  private

  def render_error(message)
    flash[:danger] = message
    redirect_to root_path
  end
end
