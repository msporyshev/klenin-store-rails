class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @root_comments = Comment.where(product_id: params[:id], comment_id: nil)
    @product_id = params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.js
      # format.js { render partial: "cur_product_comments", content_type: "text/html" }
      format.json { render json: @comment }
    end
  end

  def new
    @comment = Comment.new
    @comment.product_id = params[:product_id]
    @comment.user_id = current_user.id
    @comment.comment_id = params[:comment_id]

    respond_to do |format|
      format.html # new.html.erb
      format.js { render partial: "form", content_type: "text/html" }
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.js { render partial: "form", content_type: "text/html" }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to product_path(@comment.product), notice: 'Comment was successfully created.' }
        format.js {redirect_to comment_path(@comment.product.id, "js")}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.js {redirect_to comment_path(@comment.product.id, "js")}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.js {redirect_to comment_path(@comment.product.id, "js")}
      format.json { head :no_content }
    end
  end
end
