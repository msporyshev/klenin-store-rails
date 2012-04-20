class Admin::OrdersController < Admin::ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Cart.where("purchased_at IS NOT NULL")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

end
