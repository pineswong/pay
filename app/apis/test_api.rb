class TestAPI < Grape::API
	desc '测试' do
	end
	params do
	end
	get '/' do
		{ success: '测试成功' }
	end
end