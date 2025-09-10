class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    @expenses = Expense.all.includes(:paid_by)
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      if params[:expense][:user_ids].present?
        selected_users = User.where(id: params[:expense][:user_ids])
        @expense.split_equally_among(selected_users)
      end

      redirect_to @expense, notice: 'Expense was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: 'Expense was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy!
    redirect_to expenses_path, notice: 'Expense was successfully deleted.'
  end

  private

  def set_expense
    @expense = Expense.find(params.expect(:id))
  end

  def expense_params
    params.require(:expense).permit(:description, :amount, :date, :paid_by_id, user_ids: [])
  end
end
