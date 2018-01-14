Rails.application.routes.draw do
  resources :employees do
    resources :salaries
  end

  get "payrolls/:id/statement", to: "payrolls#statement", as: :statement
  get "payrolls/init/:year/:month", to: "payrolls#init", as: :init_payrolls, constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  resources :payrolls do
    resources :extra_entries
    resources :overtimes
  end
end
