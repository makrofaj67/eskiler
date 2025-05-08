import random
import re


class RastgeleTweetSec:
    def __init__(self):
        pass

    def siraylativitsec(self, i):
        
        with open("tweetler.txt", "r") as file:
            tweets = file.readlines()

        with open("mentionlar.txt", "r") as file:
            mentions = file.readlines()

        selected_mentions = random.sample(mentions, k=5)
        loop_count = 0

        while True:
            selected_tweet = tweets[i]
            new_tweet = selected_tweet
            for mention in selected_mentions:
                new_tweet += f" @{mention.strip()}"
            new_tweet += " #azamisüre #öğrenciaffı"

            if len(new_tweet) <= 280:
                break
            else:  
                i += 1
                
        return new_tweet
    

    def rastgeletivitsec(self):

        with open("tweetler.txt", "r") as file:
            tweets = file.readlines()

        with open("mentionlar.txt", "r") as file:
            mentions = file.readlines()

        selected_mentions = random.sample(mentions, k=5)
        loop_count = 0

        while True:
            i = random.randint(0, len(tweets) - 1)            
            selected_tweet = tweets[i]
            new_tweet = selected_tweet
            for mention in selected_mentions:
                new_tweet += f" @{mention.strip()}"
            new_tweet += " #azamisüre #öğrenciaffı"

            if len(new_tweet) <= 280:
                break
            else:
                i = random.randint(0, len(tweets) - 1)
        return new_tweet
