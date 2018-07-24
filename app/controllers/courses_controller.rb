# Created by Jeb Alawi 7/19/18
class CoursesController < ApplicationController
  # sets @course for destory method
  before_action :set_course, only: [:destroy]
  protect_from_forgery with: :null_session

  # Created by Jeb Alawi 7/19/18
  def index
    @professor = nil
    @courses = nil
    if current_professor
      @courses = current_professor.courses
      @professor = current_professor
    end
  end

  def new
    @course = Course.new
    @professor= nil
    if(current_professor)
      @professor=current_professor
    end
  end

  def create
    if current_professor
      @course = Course.new(course_params)
      @course.professor_id = current_professor.id
      if @course.save
        redirect_to current_professor
      else
        render 'new'
      end
    end
  end

  # Get all of the groups in the course
  # Created by Bin Chen 7/23/18
  def get_groups
    @course = Course.find(params[:course_id])

    render json: @course.groups
  end

  # Get all of the students in the course
  # Created by Bin Chen 7/23/18
  def get_students
    @course = Course.find(params[:course_id])

    render json: @course.students
  end

  # Created by Bin Chen 7/23/18
  def show
    @course = Course.find(params[:id])

    render json: @course
  end

  # Created by Bin Chen 7/24/18
  def add_std
    @pro = Professor.find(params[:pro_id])
    @course = @pro.courses.find(params[:course_id])

    add_student
  end

  # Created by Jeb Alawi 7/21/18
  def destroy
    if current_professor
      @course.destroy
      if current_professor
        redirect_to professor_path(current_professor.id), notice: 'Course was successfully deleted.'
      end
    end
  end

  private
  def set_course
    @course = Course.find(params[:id])
  end
  def course_params
    params.require(:course).permit(:dept, :number, :section, :name)
  end

  # Created by Bin Chen 7/24/2018
  def add_student
    unless @course.students.find(params[:std_id])
      @course.students << Student.find(params[:std_id])
    end
  end
end
