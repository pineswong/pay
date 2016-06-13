module SessionHelper
	# 登陆
	def log_in user
		session[:user_id] = user.id
	end

	def current_user
		@user ||= User.find_by(id: session[:user_id])
	end
end
