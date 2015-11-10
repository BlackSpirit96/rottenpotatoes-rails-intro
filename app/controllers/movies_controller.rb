class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    puts "###################"
    puts session[:ratings]
    puts session[:order]
    puts "###################"
    @checked_ratings = Array.new(@all_ratings)
    keys = nil
    if params.key? :ratings
      keys = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session.key? :ratings
      keys = session[:ratings].keys
    else
      redirect_to movies_path(:ratings => session[:ratings])
    end
    if keys != nil then
      @checked_ratings = Array.new()
      keys.each do |key|
        @checked_ratings << key
      end
    end
    if params.key? :sort then
      if params[:sort] == '1' then
        order = :title
      elsif params[:sort] == '2' then
        order = :release_date
      end
      session[:sort] = order
    else
      redirect_to movies_path(:sort => session[:order])
    end
    
    @movies = Movie.all
    if order != nil then
      @movies = @movies.order(order)
    end
    if keys != nil then
      @movies = @movies.where(:rating => keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
