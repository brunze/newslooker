class SearchesController < ApplicationController
  def show
    links = Link.similar_to(needle, limit: 100)

    render Backoffice::Search::Page.new(links:, needle:)
  end

  private

  def needle
    params.expect(:q)
  end
end
