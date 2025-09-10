# Rails Gotchas & Advanced Concepts

This file captures the "non-main-line" Rails concepts that come up during development - the things you learn through experience and questions.

## Console & Development

### Bang Methods (!)
**Question:** Is `!` for forcing commands?

**Answer:** Not exactly. Bang methods in Ruby/Rails are "dangerous" versions that:
1. **Modify the object in place** (mutating)
2. **Raise exceptions instead of returning false**

**Examples:**
```ruby
# Mutating vs Non-mutating
str = "hello"
str.upcase    # Returns "HELLO", str is still "hello"
str.upcase!   # Changes str to "HELLO", returns "HELLO"

# Exception vs Boolean  
user.save     # Returns false if validation fails
user.save!    # Raises ActiveRecord::RecordInvalid exception

user.destroy   # Returns the user object (even if destroy fails)
user.destroy!  # Raises exception if destroy fails
```

**When to use:** Use `!` when you want the program to crash if something goes wrong. Use regular methods when you want to handle errors gracefully.

### Rails Console Reloading
**Question:** Does the rails console need to be restarted to get recent changes?

**Answer:** Yes, but there's a shortcut! Use `reload!` instead of restarting.

```ruby
# After making model changes
reload!

# Now test your changes
user = User.new(name: "Test")
user.valid?
```

**What gets reloaded:** Model changes, controller changes, most application code  
**What doesn't get reloaded:** Gem changes, config changes, initializers

## Routing & HTTP

### Turbo Method
**Question:** When do I need `turbo_method`?

**Answer:** When using **links** (not forms) that need non-GET HTTP methods.

**The problem:** HTML links can only send GET requests, but REST needs DELETE, PATCH, PUT.

**When you need it:**
```erb
<!-- DELETE request -->
<%= link_to 'Delete', user, data: { turbo_method: :delete } %>

<!-- PATCH request -->  
<%= link_to 'Archive', archive_user_path(user), data: { turbo_method: :patch } %>
```

**When you DON'T need it:**
```erb
<!-- GET requests (default) -->
<%= link_to 'Show', user %>
<%= link_to 'Edit', edit_user_path(user) %>

<!-- Forms handle HTTP methods automatically -->
<%= form_with model: user do |form| %>
  <!-- Rails automatically uses PATCH for existing records -->
<% end %>
```

**How to know:** Check `bin/rails routes` - if the route shows DELETE/PATCH/PUT and you're using a link, you need `turbo_method`.

**Rails version note:** Rails 6 used `method: :delete`, Rails 7+ uses `data: { turbo_method: :delete }`.

### Route Generation Redundancy  
**Question:** Why did the controller generator create redundant routes?

**Answer:** When you run `rails generate controller Users index show new create...`, it assumes you want individual routes for each action. But `resources :users` already creates proper RESTful routes.

**Problem with generated routes:**
```ruby
get "users/create"    # Wrong! Should be POST /users
get "users/update"    # Wrong! Should be PATCH /users/:id  
get "users/destroy"   # Wrong! Should be DELETE /users/:id
```

**Solution:** Remove individual routes, keep only `resources :users`.

## Model Validations

### Multiple Validation Lines
**Question:** Why put email validators on separate lines?

**Answer:** Both work, but separate lines offer benefits:

```ruby
# Option 1: Combined
validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

# Option 2: Separate (preferred for complex validations)
validates :email, presence: true, uniqueness: true
validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
```

**Benefits of separation:**
- **Readability** - Easier to scan each validation type
- **Custom error messages** - Different messages per validation
- **Conditional validations** - Different conditions per validation

## Controller Patterns

### Why `destroy!` vs `destroy`
**Question:** What happens if `destroy!` raises an exception in the view?

**Answer:** The user never sees a view - Rails shows an error page.

**With `destroy!` (common approach):**
```ruby
def destroy
  @user.destroy!  # Exception if fails
  redirect_to users_path, notice: 'Deleted!'
end
```
- Success: Redirect with success message
- Failure: Rails error page (500 error)

**With `destroy` (graceful approach):**
```ruby  
def destroy
  if @user.destroy
    redirect_to users_path, notice: 'Deleted!'
  else
    redirect_to users_path, alert: 'Could not delete user.'
  end
end
```
- Success: Redirect with success message  
- Failure: Redirect with error message

**Rails convention:** Use `destroy!` because deletion failures are usually serious system errors that should be investigated, not friendly user errors.

## Development Workflow

### Server Restart vs Code Changes
- **Web requests:** Rails auto-reloads code in development mode
- **Console sessions:** Need manual `reload!` or restart
- **Config changes:** Always need full restart
- **Gem changes:** Need full restart

## Rails Magic Explained

### `resources :users` Creates:
- `GET /users` → `users#index`
- `GET /users/new` → `users#new`  
- `POST /users` → `users#create`
- `GET /users/:id` → `users#show`
- `GET /users/:id/edit` → `users#edit`
- `PATCH/PUT /users/:id` → `users#update`
- `DELETE /users/:id` → `users#destroy`

### Strong Parameters
Always use `params.require(:model).permit(:field1, :field2)` to whitelist form fields - this prevents mass assignment attacks.

### Instance Variables in Controllers
`@user` in controller becomes available in views automatically - this is Rails' way of passing data from controller to view.