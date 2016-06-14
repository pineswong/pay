class API < Grape::API
	format :json

	# 全局helper方法
	helpers do
		# 操作如果失败直接返回
		def error_by!(opt)
			error!('操作失败', 499)	 if !opt
		end

		# 操作成功返回
		def return_success
			{ success: true }
		end

		# 认证
		def authenticate!
			begin
				payload,  = JWT.decode(params[:token], 'key')
				@current_user = User.find_by(id: payload['user_id'])
			rescue StandardError
			end
			error!('认证失败', 401) if @current_user.nil?
		end

		# 获取当前用户
		def current_user
			@current_user
		end

		# 生成缴费记录
		def record!(type, account)
			record_params = Hash.new
	 		loop do
				record_params[:order] = "order#{(0..9).to_a.shuffle.join}"
				break if !Record.exists?(order: record_params[:order])
			end
			record_params[:item] = type
			record_params[:number] = account.number
			record_params[:name] = account.name
			record_params[:money] = params[:money]
			record_params[:balance] = account.balance
			@record = Record.new(record_params)
			error_by! @record.save

			@record
		end
	end

	# 挂载api
	mount FuelAPI => 'fuels'
	mount WaterAPI => 'waters'
	mount RecordAPI => 'records'
	mount SessionAPI => 'sessions'
	mount UserAPI => 'users'
	# mount TestAPI => 'tests'

	# 使用swagger自动文档
  add_swagger_documentation \
		doc_version: 'v1',
		info: {
	    title: "生活缴费系统API文档",
	    description: "包含用户缴费、管理员登陆、授权管理缴费订单、授权管理账户信息等功能",
	    contact_name: "PineWong",
	    contact_email: "pinewong@163.com",
	    # contact_url: "http://www.pinewong.com",
	    license: "PineWong",
	    license_url: "http://www.pinewong.com",
	  }
  # add_swagger_documentation base_path: 'api', hide_format: true
end