class TwitterUser < ActiveRecord::Base
   has_many :tweets

   def fetch_tweets
      client.user_timeline(self.username, count: 3)
   end

#LEARNING PORTAL
   # class User < ActiveRecord::Base
   #   def tweet(status)
   #     tweet = tweets.create!(:status => status)
   #     TweetWorker.perform_async(tweet.id)
   #   end
   # end

   def post_tweet(desc)
      tweet = self.tweets.create!(text: desc)
      TweetWorker.perform_async(tweet.id)
      # client.update(desc)
   end

   def self.find_or_created_by_username(user_info)
      if TwitterUser.exists?(username: user_info.info.nickname)
         user = TwitterUser.find_by(username: user_info.info.nickname)
         user.update(access_token: user_info.extra.access_token.token, access_token_secret: user_info.extra.access_token.secret)
         return user
      else
         TwitterUser.create(username: user_info.info.nickname, access_token: user_info.extra.access_token.token, access_token_secret: user_info.extra.access_token.secret)
      end
   end

   def post_tweet_later(desc, time)
      # byebug
      tweet = self.tweets.create!(twitter_user_id: self.id, text: desc)
     # MyWorker.perform_async(tweet.id)
      TweetWorker.perform_at(time.to_i.seconds, tweet.id)
      # client.update(tweet_msg)
   end







   private
   def client
     Twitter::REST::Client.new do |config|
         config.consumer_key        = API_KEYS["twitter_consumer_key_id"]
         config.consumer_secret     = API_KEYS["twitter_consumer_secret_key_id"]
         config.access_token        = self.access_token
         config.access_token_secret = self.access_token_secret
     end
   end
end