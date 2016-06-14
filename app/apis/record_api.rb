class RecordAPI < Grape::API
	desc '获取某类型缴费记录' do
	end
	params do
	end
	get ':item' do
		@record = Record.where(item: params[:item]).order(created_at: :desc)

    present @record, with: RecordEntity
	end


	desc '添加记录' do
		failure [
			[499, '操作失败'],
			[400, '参数错误'],
		]
	end
	params do
	 	requires :item, type: String, desc: '订单项目', message: :requires
	 	requires :number, type: String, desc: '账户号', message: :requires
	 	requires :name, type: String, desc: '户主姓名', message: :requires
	 	requires :money, type: String, desc: '缴费金额', message: :requires
	 	requires :balance, type: String, desc: '账户余额', message: :requires
	 	optional :order, type: String, desc: '订单号'
	end
	put ':item' do
		declared(params, include_missing: false)
 		loop do
			params[:order] = "order#{(0..9).to_a.shuffle.join}"
			break if !Record.exists?(order: params[:order])
		end
		# declared(params, include_missing: false)
		@record = Record.new(declared(params, include_missing: false))
		if params[:money] && params[:money].to_f <= 0
			error!('缴费金额不合法', 400)
		end
		if params[:bala
			nce] && params[:balance].to_f <= 0
			error!('账户余额不合法', 400)
		end
		error_by!(@record.save)
    return_success
	end
end