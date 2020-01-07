Rails.application.routes.draw do
  resources :employees do
    get "inactive", on: :collection
    get "parttimers", on: :collection

    resources :salaries
    get "salaries/recent/:employee_id", to: "salaries#recent", as: :salaries_recent

    resources :terms
  end

  resources :payrolls, except: [:new, :create, :show]
  get "payrolls/init_regulars/:year/:month", to: "payrolls#init_regulars", as: :init_regulars, constraints: { year: /\d{4}/, month: /\d{1,2}/ }
  get "payrolls/parttimers/:year/:month", to: "payrolls#parttimers", as: :parttimers, constraints: { year: /\d{4}/, month: /\d{1,2}/ }
  post "payrolls/parttimers/:year/:month", to: "payrolls#init_parttimers", constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  resources :statements, only: [:index, :show, :edit, :update]

  resources :reports, only: [:index] do
    collection do
      get "salary/:year", to: "reports#salary", as: :salary, constraints: { year: /\d{4}/ }
      get "service/:year", to: "reports#service", as: :service, constraints: { year: /\d{4}/ }
      get "irregular/:year", to: "reports#irregular", as: :irregular, constraints: { year: /\d{4}/ }
    end
  end

  root to: "employees#index"
end
