class LendersController < ApplicationController

	def create
		@lender = Lender.new(lender_params)

		if @lender.save
			redirect_to "/login"
		else
			flash[:lender_errors] = @lender.errors.full_messages
			redirect_to "/register"
		end
	end

	def show
		if session[:user_type] == "lender" && session[:user_id].to_s == params[:id].to_s
			@lender = Lender.find(params[:id])
			@borrower_need_money = Borrower.where("raised < money").reorder('first_name DESC')
			@borrower_got_money = History.where("lender_id = ?", @lender.id).reorder('amount DESC')
		else
			redirect_to '/login'
		end
	end


	def lend_money
		borrower = Borrower.find(lend_money_params[:borrower_id])
		lender = Lender.find(lend_money_params[:lender_id])
		if lender.money < lend_money_params[:amount].to_i
			flash[:lender_errors] = ['Insufficient Funds']
			redirect_to '/lenders/'+lender.id.to_s
			return
		end
		history = History.find_by lender_id: lend_money_params[:lender_id], borrower_id: lend_money_params[:borrower_id]
		if history != nil
			amount = history.amount + lend_money_params[:amount].to_i
			history.update_attribute :amount, amount
			lender_money_left = lender.money - history.amount
			lender.update_attribute :money, lender_money_left
			borrower_money_raised = borrower.raised + history.amount
			borrower.update_attribute :raised, borrower_money_raised
		else
			history = History.new(:lender => lender, :borrower => borrower, :amount => lend_money_params[:amount])
			if history.save
				flash[:lender_errors] = ["Thank you for lending the money"]
				lender_money_left = lender.money - history.amount
				lender.update_attribute :money, lender_money_left
				borrower_money_raised = borrower.raised + history.amount
				borrower.update_attribute :raised, borrower_money_raised
			else
				flash[:lender_errors] = history.errors.full_messages
			end
		end
		redirect_to '/lenders/'+lender.id.to_s
	end


	private
	def lender_params
		params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
	end

	private
	def lend_money_params
		params.require(:lend).permit(:lender_id, :borrower_id, :amount)
	end
end
