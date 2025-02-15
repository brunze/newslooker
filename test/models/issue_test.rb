require "test_helper"

class IssueTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid issues" do
      assert create(:issue).valid?
    end
  end

  describe "validations" do
    it "is invalid without a URL" do
      assert build(:issue, url: nil).invalid?
    end

    it "is invalid if the URL is not unique, per newsletter" do
      issue = create(:issue)

      assert build(:issue, url: issue.url, newsletter: issue.newsletter).invalid?
      assert build(:issue, url: issue.url, newsletter: build(:newsletter)).valid?
    end

    it "is invalid without a number" do
      assert build(:issue, number: nil).invalid?
    end

    it "is invalid if the number is not unique, per newsletter" do
      issue = create(:issue)

      assert build(:issue, number: issue.number, newsletter: issue.newsletter).invalid?
      assert build(:issue, number: issue.number, newsletter: build(:newsletter)).valid?
    end
  end

  describe "scraping" do
    describe "link extraction" do
      it "it fetches the HTML for the issue and builds the relevant Links it finds in it" do
        issue = create(:issue)
        scraped_links = [
          { url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1." },
          { url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2." },
          { url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3." }
        ]
        scraper = scraper_stub(links: scraped_links)
        http = http_mock(issue.url)

        issue.scrape!(scraper:, http:)

        assert_equal scraped_links, to_attributes(issue.reload.links, %i[url text blurb])
        http.verify
      end

      describe "when it encounters a link that had already been previously extracted" do
        it "replaces the existing link if it has a different text or blurb" do
          issue = create(:issue)
          issue.links.create!(url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1.")
          issue.links.create!(url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2.")

          scraped_links = [
            { url: "https://example.com/link-1", text: "Link 1, different text", blurb: "Example blurb 1." },
            { url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2, different blurb." }
          ]
          scraper = scraper_stub(links: scraped_links)
          http = http_mock(issue.url)

          issue.scrape!(scraper:, http:)

          assert_equal scraped_links, to_attributes(issue.reload.links, %i[url text blurb])
          http.verify
        end
      end

      it "preserves old links even if they disappear from the issue's page" do
        issue = create(:issue)
        issue.links.create!(url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1.")
        issue.links.create!(url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2.")

        scraped_links = [
          { url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3." }
        ]
        scraper = scraper_stub(links: scraped_links)
        http = http_mock(issue.url)

        issue.scrape!(scraper:, http:)

        assert_equal [
          { url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1." },
          { url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2." },
          { url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3." }
        ], to_attributes(issue.reload.links, %i[url text blurb])
        http.verify
      end

      it "uses the newsletter's scraper by default" do
        scraper = build(:scraper)
        newsletter = build(:newsletter, scraper:)
        issue = build(:issue, newsletter:)
        http = http_mock(issue.url)

        used_newsletter_scraper = false

        scraper.stub(:call, proc do
          used_newsletter_scraper = true
          scraper_stub.call # still need to return valid scraper results
        end) do
          issue.scrape!(http:)
        end

        assert used_newsletter_scraper
        http.verify
      end
    end

    it "updates the issue publication date if it isn't already known" do
      issue = create(:issue)
      publication_date = 42.days.ago.beginning_of_minute
      scraper = scraper_stub(publication_date:)
      http = http_mock(issue.url)

      assert_nil issue.published_at

      issue.scrape!(scraper:, http:)
      assert_equal publication_date, issue.published_at

      other_date = 3.days.ago.beginning_of_minute
      scraper = scraper_stub(publication_date: other_date)
      http.expect(:get_html, nil, [ issue.url ])

      issue.scrape!(scraper:, http:)
      assert_equal publication_date, issue.published_at

      http.verify
    end

    it "remembers when the last scrape happened" do
      issue = create(:issue)
      now = Time.current.beginning_of_minute
      scraper = scraper_stub
      http = http_mock(issue.url)

      issue.scrape!(scraper:, now:, http:)

      assert now, issue.last_scraped_at
      http.verify
    end
  end

  private

  def http_mock(url, response = nil)
    mock = Minitest::Mock.new
    mock.expect(:get_html, response, [ url ])
    mock
  end

  def scraper_stub(links: [], publication_date: 1.day.ago)
    proc { Scraper::Results.new(links:, publication_date:) }
  end
end
