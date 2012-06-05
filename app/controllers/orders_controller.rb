class OrdersController < ApplicationController
  before_filter :sign_up_if_not_signed_in, :only => :create
  # GET /orders
  # GET /orders.json
  def index
    @orders = Cart.where("user_id = ? AND purchased_at IS NOT NULL", current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Cart.find(params[:id])
    redirect_if_user_has_not_access_to_this_order and return

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_cart
    respond_to do |format|
      if @order.purchase(params[:address])
        format.html { redirect_to order_path @order, notice: 'Order was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  protected

    def redirect_if_user_has_not_access_to_this_order
      redirect_to root_url if @order.user.id != current_user.id and current_user.role != "admin"
    end

end
