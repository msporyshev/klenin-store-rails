class CartsController < ApplicationController
  before_filter :redirect_if_user_has_not_access_to_this_cart
  # GET /carts/1
  # GET /carts/1.json
  def show
    @cart = Cart.find(params[:id])

    respond_to do |format|
      format.js
      format.html # show.html.erb
      format.json { render json: @cart }
    end
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render json: @cart, status: :created, location: @cart }
      else
        format.html { render action: "new" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart = current_cart
    @cart.product_carts.each { |e| e.destroy }

    respond_to do |format|
      format.html { redirect_to root_url, :notice => "Your cart is currently empty" }
      format.json { head :no_content }
    end
  end

  protected
    def redirect_if_user_has_not_access_to_this_cart
      @cart = Cart.find_by_id(params[:id])
      if @cart
        redirect_to root_url if current_user.id != @cart.user.id
      else
        redirect_to root_url if current_cart.id  != params[:id].to_i
      end
    end

end
