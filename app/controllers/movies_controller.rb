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
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    #Used for persisting check boxes
    @selected = {}
    #If we have rations or a column header in session apply sort or filtering
    if (!params[:ratings] && !params[:sort] && (session[:ratings] || session[:sort]))
      redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort] )
    end
    @movies = Movie.all
    #If we have ratings, only get those movies
    if(params[:ratings])
      condition = params[:ratings].keys
      @movies = Movie.all.order(params[:sort]).where(:rating => condition)
      puts "RATINGS"
    end
    
    #Highlight the clicked column header
    if params[:sort] == 'title'
      @title_header = 'hilite'
    elsif params[:sort] == 'release_date'
      @release_header = 'hilite'
    end
   
   #Set values for checkboxes that were selected
    @all_ratings.each do |rating| 
      if !params[:ratings]
        @selected[rating] = true
      else
        if params[:ratings].has_key?(rating)
          @selected[rating] = true
        end 
      end 
    end
    
    #Store sort and rating data in session
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
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
