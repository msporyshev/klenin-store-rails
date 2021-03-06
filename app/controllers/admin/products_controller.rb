class Admin::ProductsController < Admin::ApplicationController

  helper_method :sort_column, :sort_direction
  # GET /admin/products
  # GET /admin/products.json
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

  # GET /admin/products/1
  # GET /admin/products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /admin/products/new
  # GET /admin/products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /admin/products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /admin/products
  # POST /admin/products.json
  def create
    # if !upload_image_and_set_its_url
    #   redirect_to :back, notice: "File is too big or has wrong extension"
    #   return
    # end
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to admin_product_path(@product), notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/products/1
  # PUT /admin/products/1.json
  def update
    # if !upload_image_and_set_its_url
    #   redirect_to :back, notice: "File is too big or has wrong extension"
    #   return
    # end
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to admin_product_path(@product), notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/1
  # DELETE /admin/products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to admin_products_url }
      format.json { head :no_content }
    end
  end

  private

    def upload_image_and_set_its_url
      uploaded_io = params[:product][:image]
      params[:product].delete("image")
      ext = File.extname(uploaded_io.original_filename)
      return nil if uploaded_io.size > 1.megabytes
      return nil if !%w[.jpg .jpeg .png .gif].include?(ext)
      image_name = params[:product][:id] || rand(1000000)
      params[:product][:image_url] = '/product_images/' + params[:product][:id].to_s + ext
      File.open(Rails.root.join('public', 'product_images', image_name.to_s + ext), 'w') do |file|
        file.write(uploaded_io.read.force_encoding("utf-8"))
      end
      true
    end

    def sort_column
      Product.column_names.include?(params[:sort_col]) ?  params[:sort_col] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:sort_dir]) ?  params[:sort_dir] : "asc"
    end

end
