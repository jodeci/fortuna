Rails.application.routes.draw do
  resources :employees do
    resources :salaries
  end

  get "payrolls/:id/statement", to: "payrolls#statement", as: :statement
  resources :payrolls do
    resources :extra_entries
    resources :overtimes
  end
end
