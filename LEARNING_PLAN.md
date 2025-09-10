# Rails Splitwise Learning Plan

This is a hands-on learning plan for building a Splitwise-like expense sharing app. The goal is to learn Rails fundamentals by building core features step-by-step.

## Learning Context
- **Goal**: Build expense sharing functionality (Users, Expenses, ExpenseShares, Groups)
- **Approach**: Step-by-step guided implementation with explanations
- **Current State**: Empty Rails 8 app with placeholder `Test` model (can be ignored/removed)
- **Available Testing**: RSpec + FactoryBot configured

## Implementation Phases

### Phase 1: User Management Foundation

#### Step 1: Create User Model
**Files to work with**: 
- `bin/rails generate model User name:string email:string`
- `db/migrate/[timestamp]_create_users.rb`
- `app/models/user.rb`

**Why start here**: Users are the foundation - everything else will reference users. In Rails, models define your data structure and business logic.

**Rails Context**: 
- Models live in `app/models/` and inherit from `ApplicationRecord`
- Migrations in `db/migrate/` define database schema changes
- ActiveRecord provides ORM functionality

#### Step 2: Add User Validations
**File**: `app/models/user.rb`

**Add**:
- Email uniqueness and presence validation
- Name presence validation
- Email format validation

**Rails Context**: ActiveRecord validations run before saving to database. They're crucial for data integrity.

#### Step 3: User Controller & Routes
**Files**:
- `config/routes.rb` - Add `resources :users`
- `bin/rails generate controller Users index show new create edit update destroy`
- `app/controllers/users_controller.rb`

**Rails Context**: 
- Routes map URLs to controller actions
- Controllers handle HTTP requests and coordinate between models and views
- RESTful routes follow convention: index, show, new, create, edit, update, destroy

#### Step 4: User Views (Basic)
**Files**: 
- `app/views/users/index.html.erb`
- `app/views/users/show.html.erb`
- `app/views/users/new.html.erb`
- `app/views/users/_form.html.erb`

**Rails Context**: Views render HTML responses. ERB templates mix HTML with Ruby code.

#### Step 5: User Testing
**Files**:
- `spec/models/user_spec.rb` (validation tests)
- `spec/requests/users_spec.rb` (controller integration tests)
- `spec/factories/users.rb` (test data factories)

**Rails Context**: RSpec provides testing framework. Model specs test business logic, request specs test HTTP interactions.

### Phase 2: Expense Core Functionality

#### Step 6: Create Expense Model
**Files**:
- `bin/rails generate model Expense description:string amount:decimal paid_by:references date:date`
- `db/migrate/[timestamp]_create_expenses.rb`
- `app/models/expense.rb`

**Rails Context**: 
- `references` creates foreign key to users table
- Decimal type for money (avoids floating point issues)
- ActiveRecord associations link models together

#### Step 7: Expense-User Association
**Files to edit**:
- `app/models/expense.rb` - Add `belongs_to :paid_by, class_name: 'User'`
- `app/models/user.rb` - Add `has_many :paid_expenses, class_name: 'Expense', foreign_key: 'paid_by_id'`

**Rails Context**: ActiveRecord associations define relationships. `belongs_to` creates method to access parent, `has_many` creates collection methods.

#### Step 8: Expense Validations
**File**: `app/models/expense.rb`

**Add**:
- Amount must be positive
- Description presence
- Date presence
- paid_by presence (should be automatic with belongs_to)

#### Step 9: Expense Controller
**Files**:
- Update `config/routes.rb` - Add `resources :expenses`
- `bin/rails generate controller Expenses index show new create edit update destroy`
- `app/controllers/expenses_controller.rb`

**Implementation notes**: 
- Index should show all expenses with who paid
- Form needs dropdown/select for paid_by user
- Strong parameters need updating

#### Step 10: Expense Views
**Files**:
- `app/views/expenses/index.html.erb` - List expenses with amount, description, paid by whom
- `app/views/expenses/show.html.erb`
- `app/views/expenses/new.html.erb`
- `app/views/expenses/_form.html.erb` - Include user dropdown for paid_by

**Rails Context**: `collection_select` helper for user dropdown, `number_field` for amount input

#### Step 11: Expense Testing
**Files**:
- `spec/models/expense_spec.rb`
- `spec/requests/expenses_spec.rb` 
- `spec/factories/expenses.rb`

### Phase 3: Expense Sharing Logic

#### Step 12: Create ExpenseShare Model
**Files**:
- `bin/rails generate model ExpenseShare expense:references user:references amount_owed:decimal`
- `db/migrate/[timestamp]_create_expense_shares.rb`
- `app/models/expense_share.rb`

**Rails Context**: Join table that connects expenses to users with additional data (amount_owed). This is the core of expense splitting.

#### Step 13: ExpenseShare Associations
**Files to edit**:
- `app/models/expense_share.rb` - Add `belongs_to :expense` and `belongs_to :user`
- `app/models/expense.rb` - Add `has_many :expense_shares` and `has_many :shared_with_users, through: :expense_shares, source: :user`
- `app/models/user.rb` - Add `has_many :expense_shares` and `has_many :shared_expenses, through: :expense_shares, source: :expense`

**Rails Context**: `has_many :through` creates many-to-many relationships with additional attributes.

#### Step 14: ExpenseShare Validations
**File**: `app/models/expense_share.rb`

**Add**:
- Amount owed must be positive
- Unique combination of expense and user (can't have duplicate shares)
- Presence validations

#### Step 15: Expense Splitting Logic
**File**: `app/models/expense.rb`

**Add methods**:
- `split_equally_among(users)` - Creates expense shares for equal split
- `total_shared_amount` - Sum of all expense shares
- `validate_shares_total` - Ensure shares don't exceed expense amount

**Rails Context**: Business logic belongs in models. Use ActiveRecord callbacks (`after_create`, `before_save`) carefully.

#### Step 16: Update Expense Form for Splitting
**Files**:
- `app/views/expenses/_form.html.erb` - Add checkboxes for users to split with
- `app/controllers/expenses_controller.rb` - Update strong params and create logic

**Rails Context**: `check_box_tag` for user selection, array parameters in strong params

#### Step 17: ExpenseShare Testing
**Files**:
- `spec/models/expense_share_spec.rb`
- Update `spec/models/expense_spec.rb` for splitting logic
- `spec/factories/expense_shares.rb`

### Phase 4: Balance Calculations

#### Step 18: User Balance Methods
**File**: `app/models/user.rb`

**Add methods**:
- `total_paid` - Sum of expenses this user paid for
- `total_owed` - Sum of expense shares this user owes
- `net_balance` - Difference between paid and owed
- `balance_with(other_user)` - How much this user owes/is owed by another user

**Rails Context**: ActiveRecord query methods (`sum`, `joins`, `where`) for database calculations

#### Step 19: Balance Display Views
**Files**:
- `app/views/users/show.html.erb` - Add balance information
- `app/views/expenses/show.html.erb` - Show who owes what for this expense
- New: `app/views/users/balances.html.erb` - Overall balance summary

**Rails Context**: Helper methods in `app/helpers/` for formatting currency

#### Step 20: Balance Controller Actions
**Files**:
- Update `config/routes.rb` - Add custom route: `get '/balances', to: 'users#balances'`
- `app/controllers/users_controller.rb` - Add `balances` action

### Phase 5: Groups (Advanced)

#### Step 21: Create Group Model
**Files**:
- `bin/rails generate model Group name:string`
- `app/models/group.rb`

#### Step 22: Group Memberships
**Files**:
- `bin/rails generate model GroupMembership group:references user:references`
- Set up associations between Group, GroupMembership, and User

#### Step 23: Group Expenses
**Files**:
- Add `group:references` to Expense model via migration
- Update Expense associations and forms

#### Step 24: Group Views and Controllers
**Files**:
- Group controller and views
- Update expense forms to optionally select group

### Phase 6: Polish and Advanced Features

#### Step 25: Settle Up Functionality
**Files**:
- Add Settlement model to track when users settle debts
- Settlement controller and views

#### Step 26: Dashboard/Home Page
**Files**:
- `app/controllers/home_controller.rb`
- `app/views/home/index.html.erb`
- Update routes to set root

#### Step 27: API Endpoints (if time allows)
**Files**:
- `config/routes.rb` - Add API namespace
- `app/controllers/api/` - JSON controllers

## Testing Strategy
- Write model specs first (validations, associations, methods)
- Add request specs for controller actions
- Use FactoryBot for test data
- Test edge cases (what happens with $0 expenses, negative amounts, etc.)

## Key Rails Concepts Covered
- Models: ActiveRecord, associations, validations, callbacks
- Controllers: RESTful actions, strong parameters, redirects/renders
- Views: ERB templates, forms, partials, helpers
- Routes: RESTful routes, custom routes, namespaces
- Database: Migrations, foreign keys, indexes
- Testing: RSpec, FactoryBot, model/request specs

## Commands Reference
- `bin/rails generate model ModelName field:type`
- `bin/rails generate controller ControllerName action1 action2`
- `bin/rails db:migrate`
- `bin/rails db:rollback`
- `bundle exec rspec`
- `bin/rails console` (for testing code interactively)
- `bin/rails server` (to run the app)

## Next Steps After Completion
- Add authentication (Devise gem)
- Add authorization (who can see/edit what)
- Improve UI with Bootstrap or Tailwind
- Add email notifications
- Deploy to Heroku/Railway