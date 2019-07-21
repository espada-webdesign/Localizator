class MapController < ApplicationController

  def index
    @ps_stores = PsStore.all
  end

  def test
  end

  def show
  end

end
