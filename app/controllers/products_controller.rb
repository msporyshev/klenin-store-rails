require "net/http"

class ProductsController < ApplicationController

  helper_method :sort_column, :sort_direction

  # GET /products
  # GET /products.json
  def index
    @category = Category.find_by_id(params[:nodeid])

    @products = Product.includes(:images).joins(:images).order("products.#{sort_column} #{sort_direction}").
      paginate(:per_page => params[:rows] || 10, :page => params[:page]).
      where("products.path LIKE ?", "#{@category.nil? ? nil : @category.path}%")

    respond_to do |format|
      format.html # index.html.erb
      format.js { render partial: "products", :content_type => "text/html"}
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.includes(:images).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  private

    def sort_column
      Product.column_names.include?(params[:sort_col]) ?  params[:sort_col] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:sort_dir]) ?  params[:sort_dir] : "asc"
    end

end
