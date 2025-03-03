class SearchesController < ApplicationController
  def show
    links = Link
      .includes(issue: [ :newsletter ])
      .similar_to(needle)
      .limit(100)
    # accepted that if it's not near the top of the results list then
    # a better needle is needed rather than another page of results

    render Backoffice::Search::Page.new(links:, needle:)
  end

  private

  def needle
    params.expect(:q)
  end
end
