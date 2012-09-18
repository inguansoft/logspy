Mapp::Application.routes.draw do

  match "rest/:entity" => "rest#service"


  match "sign_in" => "sign#in"
  match "sign_off" => "sign#off"
  match "sign_up" => "sign#up"
  match "sign_check" => "sign#check"

  root :to => 'site#index'
  

end
