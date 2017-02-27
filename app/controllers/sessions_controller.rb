class SessionsController < ApplicationController
	def new
	end

	def create
		email = params[:email]
		password = params[:password]
		lender = Lender.find_by(:email => email)
		borrower = Borrower.find_by(:email => email)
		if lender
			@lender = lender.authenticate(password)
			if @lender
				session[:user_id] = @lender.id
				session[:user_type] = 'lender'
				redirect_to '/lenders/'+@lender.id.to_s
			else
				flash[:login_messages] = ['Invalid Password']
				redirect_to '/login'
			end
		elsif borrower
			@borrower = borrower.authenticate(password)
			if @borrower
				session[:user_id] = @borrower.id
				session[:user_type] = 'borrower'
				redirect_to '/borrowers/'+@borrower.id.to_s
			else
				flash[:login_messages] = ['Invalid Password']
				redirect_to '/login'
			end
		else
			flash[:login_messages] = ['Unknown User']
			redirect_to '/login'
		end
	end

	def destroy
		session[:user_id] = nil
		session[:user_type] = nil
		flash[:login_messages] = ["You have successfully logged out"]
		redirect_to "/login"
	end
end
