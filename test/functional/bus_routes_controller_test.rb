require 'test_helper'

class BusRoutesControllerTest < ActionController::TestCase
  setup do
    @bus_route = bus_routes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bus_routes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bus_route" do
    assert_difference('BusRoute.count') do
      post :create, bus_route: { district_id: @bus_route.district_id, name: @bus_route.name }
    end

    assert_redirected_to bus_route_path(assigns(:bus_route))
  end

  test "should show bus_route" do
    get :show, id: @bus_route
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bus_route
    assert_response :success
  end

  test "should update bus_route" do
    put :update, id: @bus_route, bus_route: { district_id: @bus_route.district_id, name: @bus_route.name }
    assert_redirected_to bus_route_path(assigns(:bus_route))
  end

  test "should destroy bus_route" do
    assert_difference('BusRoute.count', -1) do
      delete :destroy, id: @bus_route
    end

    assert_redirected_to bus_routes_path
  end
end
