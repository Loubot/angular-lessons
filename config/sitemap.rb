# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.learnyourlesson.ie"

SitemapGenerator::Sitemap.public_path = 'tmp/'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                         aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                         aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                         fog_directory: ENV['FOG_DIRECTORY'],
                                         fog_region: 'eu-west-1')

SitemapGenerator::Sitemap.sitemaps_host = "https://s3-eu-west-1.amazonaws.com/angular-lessons/sitemap/"



SitemapGenerator::Sitemap.create do

  add '/welcome'
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
