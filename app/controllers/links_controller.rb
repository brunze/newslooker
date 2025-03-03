class LinksController < ApplicationController
  def index
    pagy, links = pagy_keyset(
      Link.order(created_at: :desc, id: :desc).includes(issue: [ :newsletter ]),
      tuple_comparison: true,
    )

    render Backoffice::Links::Pages::Index.new(links:, next_page_url: pagy_keyset_next_url(pagy))
  end
end
