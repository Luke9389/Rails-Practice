class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @total_users = User.count
    @total_expenses = Expense.count
    @total_amount_tracked = Expense.sum(:amount)
    @recent_expenses = Expense.includes(:paid_by).order(created_at: :desc).limit(10)
    @recent_users = User.order(created_at: :desc).limit(5)
  end

  private

  def require_admin
    return if Current.user&.admin?

    redirect_to root_path, alert: 'Access denied.'
  end
end
