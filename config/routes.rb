Rails.application.routes.draw do
  resources :employees do
    resources :salaries
  end

  get "payrolls/:year/:month", to: "payrolls#index_by_date", constraints: { year: /\d{4}/, month: /\d{1,2}/ }
  get "payrolls/:id/statement", to: "payrolls#statement", as: :statement
  resources :payrolls do
    resources :extra_entries
    resources :overtimes
  end
end
