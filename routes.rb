Rails.application.routes.draw do
# scope '/' -> run http://server:3000 (native) or http://server (inverse proxy or passenger)
# scope '/prefix_url' -> run http://server:3000/prefix_url or http://server/prefix_url (inverse proxy or passenger).
# ej: http://10.131.137.236/rubyArticulos
  scope '/' do
    get 'welcome/index'
    resources :articles
    root 'welcome#index'
  end
end
