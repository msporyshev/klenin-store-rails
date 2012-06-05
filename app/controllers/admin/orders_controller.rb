class Admin::OrdersController < Admin::ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Cart.orders.global_search(params[:search]).uniq

    @gmap_json = @orders.to_gmaps4rails { |order, marker| init_order_markers(order, marker) }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

end
