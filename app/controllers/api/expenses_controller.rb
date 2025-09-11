class Api::ExpensesController < Api::BaseController
  def index
    expenses = Current.user.all_related_expenses.includes(:paid_by, :expense_shares, :shared_with_users)
    render json: expenses_json(expenses)
  end

  def show
    expense = Expense.find(params[:id])
    render json: expense_json(expense)
  end

  def create
    expense = Expense.new(expense_params)

    if expense.save
      # Split with selected users if provided
      if params[:user_ids].present?
        selected_users = User.where(id: params[:user_ids])
        expense.split_equally_among(selected_users)
      end

      render json: expense_json(expense), status: :created
    else
      render json: { errors: expense.errors }, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:description, :amount, :date, :paid_by_id)
  end

  def expenses_json(expenses)
    {
      expenses: expenses.map { |expense| expense_json(expense) },
      total_count: expenses.count
    }
  end

  def expense_json(expense)
    {
      id: expense.id,
      description: expense.description,
      amount: expense.amount,
      date: expense.date,
      paid_by: {
        id: expense.paid_by.id,
        name: expense.paid_by.name
      },
      shares: expense.expense_shares.map do |share|
        {
          user_id: share.user.id,
          user_name: share.user.name,
          amount_owed: share.amount_owed
        }
      end,
      total_shared: expense.total_shared_amount,
      created_at: expense.created_at
    }
  end
end