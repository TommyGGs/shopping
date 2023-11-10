require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'

enable :sessions

get '/' do
  if session[:user]
    @favorites = User.find(session[:user]).favorites 
    @user = User.find(session[:user])
    @purchases = User.find(session[:user]).purchases
  end 
  @items = Item.all
  erb :index
end

get '/signup' do
  erb :signup
end

get '/signin' do
  erb :signin
end

post '/signup' do
  user = User.create(
    name: params[:name],
    email: params[:email],
    password: params[:password],
    password_confirmation: params[:password_confirmation], 
    mode_name: params[:mode_name] ) 
  if user != nil
    session[:user] = user.id
  end
  redirect '/'
end

post '/signin' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

post '/add_item' do
  Item.create(
    name: params[:name],
    price: params[:price],
    category_id: params[:category],
    image_url: params[:image_url])
  redirect '/'
end

post '/add_to_cart' do
  if !session[:user] 
    redirect '/signup'
  end 
  cart = Cart.find(params[:cart_id])
  item = Item.find(params[:item_id])
  cart.items << item
  redirect '/my_cart'
end

post '/delete/:id' do
  CartItem.find(params[:id]).delete
  redirect '/my_cart'
end

get '/category/:id' do
  @category = Category.find(params[:id])
  @user = User.find(params[:id])
  erb :category
end

get '/create_cart' do
  if !session[:user] 
    redirect '/signup'
  end 
  @user = User.find(session[:user])
  erb :create_cart
end

post '/delete_cart/:id' do 
  Cart.find(params[:id]).destroy
  redirect '/my_cart' 
end 

post '/create_cart' do
  @create_cart = Cart.create(
    user_id: session[:user])
  redirect '/create_cart'
end

get '/admin' do
  @user = User.find(session[:user])
  erb :admin
end

get '/my_cart' do
  @user = User.find(session[:user])
  @cart = Cart.where(user_id: session[:user])
  erb :my_cart
end

post '/item/:id/delete' do 
  item = Item.find(params[:id])
  if User.find(session[:user]).favorites.find_by(item_id: params[:id])
    User.find(session[:user]).favorites.find_by(item_id: params[:id]).destroy
  end 
  item.destroy
  redirect '/'
end 


get '/item/:id/edit' do 
  @user = User.find(session[:id])
   @item = Item.find(params[:id])
  erb :edit_item
end 

post '/item/:id/edit' do 
  @item = Item.find(params[:id])
  @item.update(
    name: params[:name],
    price: params[:price],
    category_id: params[:category],
    image_url: params[:image_url])
  item = Item.find(params[:id])
  redirect "/item_page/#{item.id}"
end 

post '/item/:id/favorite' do 
  @favorite = User.find(session[:user]).favorites.create(item_id: params[:id])
  item = Item.find(params[:id])
  redirect "/item_page/#{item.id}"
end 

post '/item/:id/favorite_destroy' do
  @favorite = User.find(session[:user]).favorites.find_by(item_id: params[:id]).delete
  item = Item.find(params[:id])
  redirect "/item_page/#{item.id}"
end 

post '/item/:id/favorite_destroys' do
  @favorite = User.find(session[:user]).favorites.find_by(item_id: params[:id]).delete
  item = Item.find(params[:id])
  redirect "/favorite/list"
end 

get '/favorite/list' do 
  @user = User.find(session[:user])
  @favorite = User.find(session[:user]).favorites
  # @cartitem = User.find(session[:user]).cartitem 
  erb :favorite_list
end 

post '/add_review' do 
  Review.create(
    title: params[:title],
    paragraph: params[:paragraph],
    name: params[:name],
    rating: params[:rating],
    item_id: params[:item_id]
    )
  @item = Item.find(params[:item_id])
  item = Item.find(params[:item_id])
  redirect "/item/#{item.id}/see_review"
end 

get '/edit_review/:id' do 
  @review = Review.find(params[:id])
  @user = User.find(session[:user])
  erb :edit_review
end 

post '/edit_review/:id' do 
   review = Review.find(params[:id])
   review.update(
    title: params[:title],
    paragraph: params[:paragraph],
    name: params[:name],
    rating: params[:rating]
    )
    redirect "/item/#{review.item_id}/see_review"
    #redirect '/item/0/see_review'
end 

get '/item/:id/see_review' do 
  @item = Item.find(params[:id])
  @user = User.find(session[:user])
  erb :see_item_review
end 

get '/item_review/:id/delete' do 
  Review.find(params[:id]).delete
  item = Item.find(params[:item_id])
  redirect "/item/#{item.id}/see_review"
end 

post '/search' do
  @user = User.find(session[:user])
  @items = Item.where('name like ?', '%' + params[:keyword] + '%')
  erb :index
end 

post '/purchase/:id/item' do 
  @purchase = User.find(session[:user]).purchases.create(
    item_id: params[:id],
    purchase_number: params[:purchase_number])
  @user = User.find(session[:user])
  redirect '/purchase_page'
end 

get '/purchase_page' do 
  @purchase = User.find(session[:user]).purchases
  @user = User.find(session[:user])
  erb :purchase_page
end 

post '/delete/:id/purchase' do 
  Purchase.find(params[:id]).delete
  redirect '/purchase_page'
end 

get '/item_page/:id' do 
  if session[:user]
    @favorites = User.find(session[:user]).favorites 
    @user = User.find(session[:user])
    @purchases = User.find(session[:user]).purchases
  end 
  @item = Item.find(params[:id])
  erb :item_page
end 