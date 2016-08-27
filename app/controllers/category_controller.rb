class CategoryController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_admin

  def create
    category = Category.create( category_params )

    render json: { categories: Category.all.as_json }
  end

  def update
    category = Category.find( params[:id] )
    if category.update_attributes( category_params )
      render json: { categories: Category.all.as_json }, status: 200
    else
      render json: { errors: category.errors.as_json }, status: 422
    end
  end

  # def create_subject
  #   subject = Subject.create( category_params )
  #   render json: { subjects: Subject.all.as_json }
  # end

  def index
    render json: { categories: Category.all.as_json }
  end

  private
    def category_params
      params.permit( :name, :category_id )
    end

    def check_admin
      p current_teacher
      if !current_teacher.admin
        render json: { error: "You must be an admin to do this"}, status: 403 and return
      end
    end
end