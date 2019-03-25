library(tidyverse)
library(igraph)

# Read in File
movies = read.csv("C:/Users/Andy Dotter/Documents/05_Spring_2019/Spring_2/Social Network Analytics/movie_metadata.csv")

# Get columnames
colnames(movies)


# Isolate for important columns only
movies_short <- movies %>% select(c('movie_title', 'actor_1_name', 'actor_2_name', 'actor_3_name', 'imdb_score', 'gross'))

movies_short$actor_1_name <- as.character(movies_short$actor_1_name)
movies_short$actor_2_name <- as.character(movies_short$actor_2_name)
movies_short$actor_3_name <- as.character(movies_short$actor_3_name)
movies_short$movie_title <- as.character(movies_short$movie_title)

# Preview the data
head(movies_short)


# Sort by most revenue generating movies
movies_short <- arrange(movies_short, desc(gross))

# filter for top 250 movies by rating
movies_short <- head(movies_short, n=250)

# Actor 1 to Actor 2
# Rbind Actor 1 to actor 3
# R bind Actor 2 to actor 3

# actors 1 and 2
M1 <- movies_short %>% select(c('actor_1_name', 'actor_2_name', 'imdb_score', 'gross', 'movie_title'))

# actors 1 and 3
M2 <- movies_short %>% select(c('actor_1_name', 'actor_3_name', 'imdb_score', 'gross', 'movie_title'))

# actors 2 and 3
M3 <- movies_short %>% select(c('actor_2_name', 'actor_3_name', 'imdb_score', 'gross', 'movie_title'))

# align all the column names for the R bind
colnames(M1)
names(M1) <- c("From", "To", "imbd_score", "gross", "movie_title")
colnames(M2)
names(M2) <- c("From", "To", "imdb_score", "gross", "movie_title")
colnames(M3)
names(M3) <- c("From", "To", "imdb_score", "gross", "movie_title")

colnames(M1) = colnames(M2)
colnames(M3) = colnames(M2)

# Bind the data together
all_in <- rbind(M1, M2)
all_in <- rbind(all_in, M3)
head(all_in)

all_in$movie_title2 <- trimws(all_in$movie_title, which = c("both")) #, whitespace = "[ \t\r\n]")

all_in$movie_title2 = substr(all_in$movie_title2,1,nchar(all_in$movie_title2)-2)
head(all_in)

Encoding(all_in$movie_title) <- "UTF-8"

all_in <- all_in %>% select(-c(movie_title2))

Don <- all_in %>% filter(To == "Don Rickles")
# Remove the movie title, although I think I can leave it in as well
all_in <- all_in %>% select(-c("movie_title"))

# Clear out the old network file
rm(networkfile)
# Create an igraph object with the dataframe
networkfile <- igraph::graph_from_data_frame(all_in, directed = FALSE, vertices = NULL)

comps <- components(networkfile)

comps$csize[2]

graphs <- decompose(networkfile)

# This allows us to export as a gexf file to import into gephi
library(rgexf)
setwd('C:/Users/Andy Dotter/Documents/05_Spring_2019/Spring_2/Social Network Analytics')
g1.gexf <- igraph.to.gexf(networkfile)
# Get largest connected component
g2.gexf <- igraph.to.gexf(graphs[[2]])

# You have to create a file connection.
f <- file("networkfile.gexf")
writeLines(g1.gexf$graph, con = f)
close(f)


f2 <- file("single_component.gexf")
writeLines(g2.gexf$graph, con = f2)
close(f2)

