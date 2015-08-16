class CreateTweets < ActiveRecord::Migration
  def change
  	create_table :tweets do |t|
  		t.text :text, index: true
  		t.integer :twitter_user_id, index: true

  		t.timestamps null: false
  	end
  end
end
