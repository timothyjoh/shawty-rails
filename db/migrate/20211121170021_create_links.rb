# frozen_string_literal: true

# Creation of the Links Table, where we store all the URLs for redirect
class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :url, null: false
      t.string :slug, index: { unique: true }
      t.string :secret, null: false
      t.timestamps
    end
  end
end
