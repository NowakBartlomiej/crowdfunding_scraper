class CollectionController < ApplicationController
  def index
    @collections = Collection.all.limit(50)
  end
end
