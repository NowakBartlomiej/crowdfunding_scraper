class CollectionsController < ApplicationController
  def index
    @pagy, @collections = pagy(Collection.all)
    # @collections = Collection.all.limit(50)
  end
end
