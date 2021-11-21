# frozen_string_literal: true

# Links are the URLs that get shortened and stored
class Link < ApplicationRecord
  validates :slug,
            presence: true,
            uniqueness: { case_sensitive: false }
  validates :url, presence: true
  validates :secret, presence: true

  after_initialize(:generate_slug)
  after_initialize(:generate_secret)
  after_initialize(:slugify_slug)

  private

  def generate_slug
    self.slug = Faker::Alphanumeric.alphanumeric(number: 8) if slug.blank?
  end

  def generate_secret
    self.secret = Faker::Alphanumeric.alphanumeric(number: 16) if secret.blank?
  end

  def slugify_slug
    generate_slug
    self.slug = slug.parameterize
  end
end
