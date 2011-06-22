(function() {
  var loadTweets, pickTweet, renderTweet, settings;
  settings = {
    screen_name: 'gathergranola',
    count: 20,
    include_rts: false,
    default_text: 'Follow us on Twitter &raquo;',
    hashtag: '#buygg'
  };
  loadTweets = function() {
    var data, url;
    url = "http://api.twitter.com/1/statuses/user_timeline.json";
    data = {
      screen_name: settings.screen_name,
      count: settings.count,
      include_rts: settings.include_rts
    };
    return $.get(url, data, pickTweet, "jsonp");
  };
  pickTweet = function(tweet_list) {
    var selected_tweet, tweet, _i, _len;
    selected_tweet = null;
    for (_i = 0, _len = tweet_list.length; _i < _len; _i++) {
      tweet = tweet_list[_i];
      if (tweet.text.match(settings.hashtag)) {
        selected_tweet = tweet;
        break;
      }
    }
    return renderTweet(selected_tweet);
  };
  renderTweet = function(tweet) {
    var text;
    text = (tweet != null ? tweet.text : void 0) || settings.default_text;
    text = text.replace(settings.hashtag, '');
    return $('#twitter').html("" + text);
  };
  document.onready = loadTweets;
}).call(this);
