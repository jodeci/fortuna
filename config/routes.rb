Rails.application.routes.draw do
  resources :employees do
    get "inactive", on: :collection

    resources :salaries
    get "salaries/recent/:employee_id", to: "salaries#recent", as: :salaries_recent
  end

  resources :payrolls, except: [:new, :create, :show]
  get "payrolls/init/:year/:month", to: "payrolls#init", as: :init_payrolls, constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  resources :statements, only: [:index, :show]
  
  root to: "employees#index"
end
