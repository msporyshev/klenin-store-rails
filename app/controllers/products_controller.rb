class ProductsController < ApplicationController

  helper_method :sort_column, :sort_direction
  # GET /products
  # GET /products.json
  def index
    @category = Category.find_by_id(params[:nodeid])

    @products = Product.order(sort_column + " " + sort_direction).
                  paginate(:per_page => params[:rows] || 20, :page => params[:page]).
                  where("path LIKE ?", "#{@category.nil? ? nil : @category.path}%")


    respond_to do |format|
      format.html # index.html.erb
      format.js { render partial: "products", :content_type => "text/html"}
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
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
