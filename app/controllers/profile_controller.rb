class ProfileController < ApplicationController
  def show
  end

  def edit
  end

  def update
    if current_user.update_personal_attributes(params[:user])
      redirect_to profile_path, notice: 'Your personal data was updated successfully'
    else
      current_user.reload
      render_edit_with_alert('Your personal data failed to update')
    end
  end

  def change_password
    ensure_valid_password(params[:current_password],
      'Current password was incorrect') do
      current_user.password_confirmation = params[:password_confirmation]
      if current_user.change_password!(params[:password])
        redirect_to profile_path, notice: 'Your password was changed successfully'
      else
        current_user.reload
        render_edit_with_alert(%q{The new passwords didn't matched})
      end
    end
  end

  def change_email
    ensure_valid_password(params[:password], 'Given password was incorrect') do
      ensure_valid_email(params[:email]) do
        if current_user.deliver_change_email_instructions!(params[:email])
          redirect_to profile_path, notice: 'An email with instructions was sent to you'
        else
          render_edit_with_alert('The new email is already taken')
        end
      end
    end
  end

  private

  def render_edit_with_alert(message)
    flash.now.alert = message
    render :edit
  end

  def ensure_valid_password(password, fail_message, &block)
    if User.authenticate(current_user.username, password)
      yield if block_given?
    else
      render_edit_with_alert(fail_message)
    end
  end

  def ensure_valid_email(email)
    if User.valid_email?(email)
      yield if block_given?
    else
      render_edit_with_alert('The new email was incorrect')
    end
  end
end
