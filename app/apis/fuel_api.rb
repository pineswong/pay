class FuelAPI < Grape::API
	desc '检索账户' do
		# success FuelEntity
		failure [
			[404, '没有找到该账户'],
		]
	end
	params do
		requires :number, type: String, message: :requires, desc: '账户编号'
		# requires :name, type: String, message: :requires, desc: '户主姓名'
	end
	get 'search' do
		@fuel = Fuel.find_by(number: params[:number])
		error!('没有找到该账户', 404) if @fuel.nil?
    # present @fuel, with: FuelEntity
    present @fuel, with: FuelEntity
	end


	desc '快捷缴费' do
		# success FuelEntity
		failure [
			[404, '没有找到该账户'],
			[499, '操作失败'],
			[498, '缴费金额不合理'],
		]
	end
	params do
		requires :number, type: String, message: :requires, desc: '账户编号'
		requires :name, type: String, message: :requires, desc: '户主姓名'
		requires :money, type: String, message: :requires, desc: '缴费金额'
	end
	patch 'quickpay' do
		@fuel = Fuel.where(number: params[:number], name: params[:name]).first
		error!('没有找到该账户', 404) if @fuel.nil?
		error!('缴费金额不合理', 498) if params[:money].nil? || params[:money].to_f<=0
		error!('操作失败', 499) if !@fuel.update_attribute(:balance, @fuel.balance+params[:money].to_f)
    # present @fuel, with: FuelEntity
    { '当前账户余额': @fuel.balance }
	end


	desc '缴费' do
		# success FuelEntity
		failure [
			[404, '没有找到该账户'],
			[499, '操作失败'],
			[498, '缴费金额不合理'],
		]
	end
	params do
		requires :id, type: Integer, message: :requires, desc: '账户ID'
		requires :money, type: String, message: :requires, desc: '缴费金额'
	end
	patch 'pay' do
		@fuel = Fuel.find_by(id: params[:id])
		error!('没有找到该账户', 404) if @fuel.nil?
		error!('缴费金额不合理', 498) if params[:money].nil? || params[:money].to_f<=0
		error!('操作失败', 499) if !@fuel.update_attribute(:balance, @fuel.balance+params[:money].to_f)
    # present @fuel, with: FuelEntity
    { '当前账户余额': @fuel.balance }
	end


	desc '多项匹配账户信息' do
		# success FuelEntity
		failure [
			[404, '没有找到该账户'],
		]
	end
	params do
		requires :number, type: String, message: :requires, desc: '账户号'
		requires :name, type: String, message: :requires, desc: '户主姓名'
	end
	post 'match' do
		@fuel = Fuel.where(number: params[:number], name: params[:name]).first
		# 账户不存在
		if @fuel.nil?
			error!('没有找到该账户', 404)
		end
    present @fuel, with: FuelEntity
	end


	params do
		# requires :token, type: String, desc: '用户授权凭证，登录成功时获取', message: :requires
	end
	namespace do
		before do
			# authenticate!
		end

		desc '获取账户信息' do
			# success FuelEntity
			failure [
				[401, '认证失败'],
				[400, 'ID参数出错'],
				[404, '没有找到该账户'],
			]
		end
		params do
			requires :id, type: Integer, message: :requires, desc: '账户ID'
		end
		get ':id' do
			@fuel = Fuel.find_by(id: params[:id])
			# id账户不存在
			if @fuel.nil?
				error!('没有找到该账户', 404)
			end
	    present @fuel, with: FuelEntity
		end


		desc '获取所有账户' do
			# success FuelEntity
		end
		params do
		end
		get '/' do
			@fuels = Fuel.order(created_at: :desc)
	    present @fuels, with: FuelEntity
		end


		desc '创建账户信息' do
			failure [
				[401, '认证失败'],
				[498, '账户号已存在'],
				[499, '操作失败'],
			]
		end
		params do
	 		requires :number, type: String, desc: '账户号', message: :requires
	 		requires :unit, type: String, desc: '收费单位', message: :requires
	 		requires :name, type: String, desc: '户主姓名', message: :requires
	 		optional :address, type: String, desc: '户主地址'
	 		optional :balance, type: String, desc: '账户余额'
	 		optional :deleted, type: Boolean, desc: '账户未激活？'
		end
		post '/' do
			if Fuel.exists?(number: params[:number])
				error!('账户号已存在', 498)
			end
			if params[:balance] && params[:balance].to_f <= 0
				error!('账户余额不合法', 400)
			end
			# @fuel = Fuel.new(params.permit(:number, :unit, :name, :address, :balance, :deleted))
			@fuel = Fuel.new(declared(params, include_missing: false))
			# 执行操作，失败直接返回
			error_by!(@fuel.save)
			# 正确返回
			return_success
		end


		desc '修改账户信息' do
			# success FuelEntity
			failure [
				[401, '认证失败'],
				[400, 'ID参数出错'],
				[404, '没有找到该账户'],
				[499, '操作失败'],
				[498, '账户号已存在'],
			]
		end
		params do
			requires :id, type: Integer, desc: '账户ID', message: :requires
	 		optional :number, type: String, desc: '账户号'
	 		optional :unit, type: String, desc: '收费单位'
	 		optional :name, type: String, desc: '户主姓名'
	 		optional :address, type: String, desc: '户主地址'
	 		optional :balance, type: String, desc: '账户余额'
	 		optional :deleted, type: Boolean, desc: '账户未激活？'
		end
		patch ':id' do
			@fuel = Fuel.find_by(id: params[:id])
			if @fuel.nil?
				error!('没有找到该账户', 404)
			end
			if @fuel.number != params[:number] && Fuel.exists?(number: params[:number])
				error!('账户编号已存在', 498)
			end
			if params[:balance] && params[:balance].to_f <= 0
				error!('账户余额不合法', 400)
			end
			# 执行操作，失败直接返回
			error_by!(@fuel.update(declared(params, include_missing: false)))
			# 正确返回
			return_success
		end
		

		desc '删除账户信息' do
			# success FuelEntity
			failure [
				[401, '认证失败'],
				[400, 'ID参数出错'],
				[404, '没有找到该账户'],
				[499, '操作失败'],
			]
		end
		params do
			requires :id, type: Integer, desc: '账户ID', message: :requires
		end
		delete ':id' do
			@fuel = Fuel.find_by(id: params[:id])
			if @fuel.nil?
				error!('没有找到该账户', 404)
			end
			# 执行操作，失败直接返回
			error_by!(@fuel.destroy)
			# 正确返回
			return_success
		end
	end
end