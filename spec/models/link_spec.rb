# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Link, type: :model do
  context 'validations' do
    subject { Link.new(url: 'https://mysecret.com') }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug).case_insensitive }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:secret) }
  end

  context 'url only' do
    subject { Link.create(url: 'https://mysecret.com') }

    it 'should be valid' do
      expect(subject).to be_valid
    end

    it 'should generate a slug' do
      expect(subject.slug).to_not be_blank
    end

    it 'should generate a secret' do
      expect(subject.secret).to_not be_blank
    end
  end

  context 'url with slug' do
    subject { Link.create(url: 'https://mysecret.com', slug: 'secretive') }

    it 'should generate a slug' do
      expect(subject.slug).to_not be_blank
      expect(subject.slug).to eq('secretive')
    end
  end

  context 'url with slug (not URL friendly)' do
    subject { Link.create(url: 'https://mysecret.com', slug: 'I would like to keep this secret') }

    it 'should generate a slug' do
      expect(subject.slug).to_not be_blank
      expect(subject.slug).to eq('i-would-like-to-keep-this-secret')
    end
  end
end
# rubocop:enable Metrics/BlockLength
