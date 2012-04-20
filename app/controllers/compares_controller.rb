class ComparesController < ApplicationController

  def create
    @compare = Compare.new({:user_id => current_user.id.to_i, :product_id => params[:product_id].to_i})

    respond_to do |format|
      if @compare.save
        @product = @compare.product
        format.js { render "compare_buttons" }
        format.html { redirect_to compares_url, :notice => "Compare successfully added"}
      else
        format.html { redirect :back }
      end
    end
  end

  def index
    @compares = Compare.where(:user_id => current_user.id)

    respond_to do |format|
      format.html
    end
  end

  def destroy
    @compare = Compare.find(params[:id])
    @product = @compare.product
    @compare.destroy

    respond_to do |format|
      format.js { render "compare_buttons" }
      format.html { redirect_to compares_url }
      format.json { head :no_content }
    end
  end
end
