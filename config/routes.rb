Rails.application.routes.draw do
  resources :employees do
    get "inactive", on: :collection

    resources :salaries
    get "salaries/recent/:employee_id", to: "salaries#recent", as: :salaries_recent

    resources :terms
  end

  resources :payrolls, except: [:new, :create, :show]
  get "payrolls/init/:year/:month", to: "payrolls#init", as: :init_payrolls, constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  resources :statements, only: [:index, :show, :edit, :update]

  resources :lunar_years, except: [:index, :show, :destroy]

  get "yearend_bonuses/lunar_year/:lunar_year_id", to: "yearend_bonuses#lunar_year", as: :yearend_bonuses_lunar_year
  resources :yearend_bonuses, except: [:destroy]

  resources :reports, only: [:index] do
    collection do
      get "salary/:year", to: "reports#salary", as: :salary, constraints: { year: /\d{4}/ }
      get "service/:year", to: "reports#service", as: :service, constraints: { year: /\d{4}/ }
      get "irregular/:year", to: "reports#irregular", as: :irregular, constraints: { year: /\d{4}/ }
    end
  end

  root to: "employees#index"
end
