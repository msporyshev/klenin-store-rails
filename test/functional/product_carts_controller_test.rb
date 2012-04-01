require 'test_helper'

class ProductCartsControllerTest < ActionController::TestCase
  setup do
    @product_cart = product_carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_cart" do
    assert_difference('ProductCart.count') do
      post :create, product_cart: @product_cart.attributes
    end

    assert_redirected_to product_cart_path(assigns(:product_cart))
  end

  test "should show product_cart" do
    get :show, id: @product_cart
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_cart
    assert_response :success
  end

  test "should update product_cart" do
    put :update, id: @product_cart, product_cart: @product_cart.attributes
    assert_redirected_to product_cart_path(assigns(:product_cart))
  end

  test "should destroy product_cart" do
    assert_difference('ProductCart.count', -1) do
      delete :destroy, id: @product_cart
    end

    assert_redirected_to product_carts_path
  end
end
