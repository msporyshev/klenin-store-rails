class RatingsController < ApplicationController
  def show
    @product = Product.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.js { render "show.js.erb"  }
      format.json { render json: @comment }
    end
  end

  def create
    @rating = Rating.new(params[:rating])

    respond_to do |format|
      if @rating.save
        format.js {redirect_to rating_path(@rating.product.id, "js")}
        format.json { render json: @rating, status: :created, location: @rating }
      else
        format.html { render action: "new" }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
        format.js {redirect_to rating_path(@rating.product_id, "js")}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end
end
