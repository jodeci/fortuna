Rails.application.routes.draw do
  resources :employees do
    resources :salaries
  end

  resources :payrolls
  get "payrolls/init/:year/:month", to: "payrolls#init", as: :init_payrolls, constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  resources :statements, only: [:index, :show]
end
