class GalaxiesController < ApplicationController
    before_action :require_login
    helper_method :params
    before_action :set_galaxy, only: [:show, :edit, :update, :destroy]

    def most_recent
        @galaxy = Galaxy.most_recent
    end

    def index
        if params[:user_id] && User.exists?(params[:user_id])
            @galaxies = User.find(params[:user_id]).galaxies
        else
            @galaxies = Galaxy.search(params[:search])
        end
    end

    def show
    end

    def new
        @galaxy = Galaxy.new(user_id: params[:user_id])
    end

    def edit
        
    end

    def create
        @galaxy = Galaxy.new(galaxy_params)
        if @galaxy.valid?
            @galaxy.save
            redirect_to galaxies_path
        else
            render :new
        end
    end

    def update
        if @galaxy.update(galaxy_params)
            redirect_to galaxy_path
        else
            render :edit
        end
    end

    def destroy
        @galaxy.destroy
        redirect_to galaxies_path
    end

    private

    def set_galaxy
        @galaxy = Galaxy.find(params[:id])
    end

    def galaxy_params
        params.require(:galaxy).permit(:name, :user_id, :search)
    end

    def require_login
        return head(:forbidden) unless session.include? :user_id
    end
end