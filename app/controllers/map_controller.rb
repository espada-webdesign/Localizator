class MapController < ApplicationController

  def index
    @ps_stores = PsStore.all.order('layer DESC')
  end


end
