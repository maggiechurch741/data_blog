
library(tidytext)
library(dplyr)
library(ggplot2)
library(stringr)

# I'll limit it to comms tweets during the debate, for candidates who participated

# Pull our handles
full <- read_csv("~/Documents/Coding/data_blog/data/full_staffers.csv") %>%
  mutate(Handle = str_replace_all(Handle, "@", "")) %>%
  filter(Handle != "N/A")
         
comms <- read_csv("~/Documents/Coding/data_blog/data/comms_staffers.csv") %>%
  mutate(Handle = str_replace_all(Handle, "@", "")) %>%
  filter(Handle != "N/A")

# https://ballotpedia.org/Presidential_election_key_staffers,_2020


library(rtweet)

# Setup twitter access
appname <- "staffscrape"
key <- "RTiH1TQcJLP4O8cYjlRuwZKe4"
secret <- "9vgduSJISaYTQ23IdVgkPVh9wVmAzW3leqSjKAco73q1gfK7Yg"
access_token <- "1197145858829099008-Nnw1OqbF1ZfCvW08fUtQtditmTWaTI"
access_secret <- "JnIeiD5RHrSnVSq8JRJpK5PMF6qGFN1S8LSZkuUUgRXoM"

twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)

# Get all original tweets from debate day, 11/21/2019
tweets <- get_timeline(user = comms$Handle, 
                       n = 1000) %>%
  mutate(date = substr(as.character(created_at), 1, 10)) %>%
  filter(date == "2019-11-21") %>%
  select(c(screen_name, 
           text, 
           is_quote, 
           is_retweet,
           favorite_count,
           retweet_count)) %>%
  rename(Handle = screen_name)

# Merge back with comms df to find corresponding candidate
df <- inner_join(comms, tweets, by = c("Handle" = "screen_name"))


# Time to analyze
summdf <- df %>% 
  group_by(Candidate) %>%
  summarize(n = n())
group_by
