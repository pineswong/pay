class FuelsController < ApplicationController
	before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]

	def pay
	end

	def order
		
	end

	def index
		@fuels = Fuel.order(created_at: :desc)
	end
	
	def new
	end
	
	def edit
	end
	
	def show
	end
	
	def create
		@fuel = Fuel.new(fuel_params)

		if !@fuel.save
			flash[:danger] = '创建失败'
			render 'new' and return
		end

		flash[:success] = '创建成功'
		redirect_to fuels_url
	end
	
	def update
		@fuel = Fuel.find(params[:id])

		if !@fuel.update(fuel_params)
			flash[:danger] = '修改失败'
			render 'edit' and return
		end

		flash[:success] = '修改成功'
		redirect_to fuels_url
	end
	
	def destroy
		@fuel = Fuel.find(params[:id])

		if !@fuel.destroy
			flash[:danger] = '删除失败'
			render 'index' and return
		end

		flash[:success] = '删除成功'
		redirect_to fuels_url
	end

	private
		def fuel_params
			params.require(:fuel).permit(:number, :unit, :name, :address, :balance)
		end
end
