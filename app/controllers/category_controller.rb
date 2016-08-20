class CategoryController < ApplicationController
  before_action :authenticate_teacher!

  def create
    category = Category.create( category_params )

    render json: { categories: Category.all.as_json }
  end

  def create_subject
    subject = Subject.create( category_params )
    render json: { subjects: Subject.all.as_json }
  end

  def index
    render json: { categories: Category.all.as_json }
  end

  private
    def category_params
      params.permit( :name, :category_id )
    end
end