require 'test_helper'

class PdfsControllerTest < ActionController::TestCase
  setup do
    @pdf = pdfs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pdfs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pdf" do
    assert_difference('Pdf.count') do
      post :create, pdf: { file_content_type: @pdf.file_content_type, file_file_name: @pdf.file_file_name, file_file_size: @pdf.file_file_size, file_updated_at: @pdf.file_updated_at, name: @pdf.name, template_id: @pdf.template_id }
    end

    assert_redirected_to pdf_path(assigns(:pdf))
  end

  test "should show pdf" do
    get :show, id: @pdf
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pdf
    assert_response :success
  end

  test "should update pdf" do
    put :update, id: @pdf, pdf: { file_content_type: @pdf.file_content_type, file_file_name: @pdf.file_file_name, file_file_size: @pdf.file_file_size, file_updated_at: @pdf.file_updated_at, name: @pdf.name, template_id: @pdf.template_id }
    assert_redirected_to pdf_path(assigns(:pdf))
  end

  test "should destroy pdf" do
    assert_difference('Pdf.count', -1) do
      delete :destroy, id: @pdf
    end

    assert_redirected_to pdfs_path
  end
end
