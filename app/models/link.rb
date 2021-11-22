# frozen_string_literal: true

# Links are the URLs that get shortened and stored
class Link < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :slug,
            presence: true,
            uniqueness: { case_sensitive: false }
  validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :secret, presence: true

  after_initialize(:generate_secret)
  after_initialize(:slugify_slug)
  before_save(:slugify_slug)

  def mutation_key
    "#{slug}-#{secret}"
  end

  def to_param
    mutation_key
  end

  def self.find_by_mutation_key(mkey)
    maybeslug, maybesecret = mkey.split('-')
    find_by(slug: maybeslug, secret: maybesecret)
  end

  def shorty
    short_url(slug)
  end

  def editable
    editable_url(mutation_key)
  end

  private

  def generate_slug
    self.slug = Faker::Alphanumeric.alphanumeric(number: 8) if slug.blank?
  end

  def generate_secret
    self.secret = Faker::Alphanumeric.alphanumeric(number: 16) if secret.blank?
  end

  def slugify_slug
    generate_slug
    self.slug = slug.parameterize(separator: '_')
  end
end
