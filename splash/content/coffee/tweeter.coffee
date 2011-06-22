# load latest tweet that has an upcoming date and #buygg
# if day has passed, show Follow us on Twitter »

settings =
    screen_name     : 'gathergranola'
    count           : 20
    include_rts     : false
    default_text    : 'Follow us on Twitter &raquo;'
    hashtag         : '#buygg'

loadTweets = ->
    url = "http://api.twitter.com/1/statuses/user_timeline.json"
    data =
        screen_name : settings.screen_name
        count       : settings.count
        include_rts : settings.include_rts

    $.get(url, data, pickTweet, "jsonp")    

pickTweet = (tweet_list) ->
    selected_tweet = null
    for tweet in tweet_list
        if tweet.text.match(settings.hashtag)
            selected_tweet = tweet
            break
    renderTweet(selected_tweet)

renderTweet = (tweet) ->
    text = tweet?.text or settings.default_text
    text = text.replace(settings.hashtag, '')
    $('#twitter').html("#{ text }")

document.onready = loadTweets
