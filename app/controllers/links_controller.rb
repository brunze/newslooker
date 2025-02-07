class LinksController < ApplicationController
  def index
    @links = if needle
      Link.similar_to(needle, limit: 10)
    else
      Link.all.limit(10)
    end
  end

  private

  def needle
    params[:q]
  end
end
