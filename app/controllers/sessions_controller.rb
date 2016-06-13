require 'net/http'  

class SessionsController < ApplicationController
	include SessionHelper		# 引用log_in辅助方法

  def new
  end

  def create
    # url = 'http://localhost:3000/api/tests'
    # response = Net::HTTP.get_response(URI(url))
    # render json: response
    # uri = URI('http://localhost:3000/api/sessions')


  	user = User.find_by(username: params[:username])

  	# 失败
  	if !user || !user.authenticate(params[:password])
	  	flash.now[:danger] = "登录失败"
	  	render 'new' and return
	  end

	  # 成功
  	log_in user
  	flash[:success] = "登录成功, 欢迎管理员 ‘#{current_user.username}’"
  	redirect_to fuels_url and return
  end

  def destroy
    log_out
  	flash[:success] = '注销成功'
  	redirect_to login_url and return
  end

  private
  	def session_params
  		params.require(:user).permit(:username, :password)
  	end
end
