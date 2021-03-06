# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.learnyourlesson.ie"
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog (pass in configuration values as shown above if needed) 
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new # inform the map cross-linking where to find the other maps 
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
# pick a namespace within your bucket to organize your maps SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'


SitemapGenerator::Sitemap.create do
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

  add '/welcome'

  add '/how-it-works'

  add '/register-teacher'

  add '/contact'

  add '/about'

  Subject.all.each do |s|
    add "/search/#{ s.name }"
  end

  Teacher.where( is_teacher: true ).each do |t|

    add "/view-teacher/#{ t.id }"
  end

  
  
end

SitemapGenerator::Sitemap.ping_search_engines('https://www.learnyourlesson.ie/sitemap.xml.gz')