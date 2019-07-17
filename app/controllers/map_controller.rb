class MapController < ApplicationController

  def index
    @ps_stores = PsStore.all
  end

  def show
    @ps_store = PsStore.find(params[:id])
  end

  def new
    @ps_store = PsStore.new
  end

end
