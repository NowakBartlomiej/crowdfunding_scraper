class TableController < ApplicationController
  include Pagy::Backend
  @pagy, @collections = pagy(Collection.all)
  def index
  end
end
