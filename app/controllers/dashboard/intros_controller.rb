class Dashboard::IntrosController < ApplicationController
  def index
    @intros = Intro.page(params[:page])
  end

  def edit
    @intro = Intro.find(params[:id])
  end

  def new
    @intro = Intro.new
  end

  def update
    @intro = Intro.find(params[:id])

    respond_to do |format|
      if @intro.update_attributes(intro_params)
        flash[:notice] = 'Intro was successfully updated.'
        format.html { redirect_to(dashboard_intros_path) }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def create
    @intro = Intro.new(intro_params)

    respond_to do |format|
      if @intro.save
        flash[:notice] = 'Intro was successfully created.'
        format.html { redirect_to(dashboard_intros_path) }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def destroy
    @intro = Intro.find(params[:id])
    @intro.destroy

    respond_to do |format|
      format.html { redirect_to(intros_url) }
    end
  end

  def intro_params
    params[:intro].permit(:title, :content, :desc)
  end
end
