class ProductCartsController < ApplicationController
  # POST /product_carts
  # POST /product_carts.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])


    @product_cart = @cart.add_product(product.id)


    respond_to do |format|
      if @product_cart.save
        format.html { redirect_to @product_cart.cart, notice: 'Product cart was successfully created.' }
        format.json { render json: @product_cart, status: :created, location: @product_cart }
      else
        format.html { render action: "new" }
        format.json { render json: @product_cart.errors, status: :unprocessable_entity }
      end
    end
  end
end
