class AddArtistAndOpinionToTweets < ActiveRecord::Migration[7.1]
  def change
    add_column :tweets, :artist, :string
    add_column :tweets, :opinion, :text
  end
end
