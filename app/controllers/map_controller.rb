class MapController < ApplicationController

  def index
    @ps_stores = PsStore.all
  end


end
