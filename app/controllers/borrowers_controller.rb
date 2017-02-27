class BorrowersController < ApplicationController

	def create
		@borrower = Borrower.new(borrower_params)
		if @borrower.save
			redirect_to "/login"
		else
			flash[:borrower_errors] = @borrower.errors.full_messages
			redirect_to "users/register"
		end
	end

	def show
		if session[:user_type] == "borrower" && session[:user_id].to_s == params[:id].to_s
			@borrower = Borrower.find(params[:id])
			@lending_history = History.where("borrower_id = ?", @borrower.id).reorder('amount DESC')
		else
			redirect_to '/login'
		end
	end


	private
	def borrower_params
		params.require(:borrower).permit(:first_name, :last_name, :email, :password, :money, :purpose, :description, :raised)
	end
end
