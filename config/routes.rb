Rails.application.routes.draw do
  resources :employees do
    resources :salaries
    resources :payrolls
  end

  resources :payrolls
end
