library(readr)
library(tidyr)
library(igraph)
dat <- read_csv('C:\\Users\\lasky\\Google Drive\\Graduate School _ Jobs\\NCSU MSA\\Personal Projects\\IMDB Network Analysis\\imdb_network\\movie_metadata.csv')
colnames(dat)
dat <- dat[,-1]
##columns need to be
gephi_col_names <- c('Source', 'Target', 'Type', 'Id', 'Label', 'Interval', 'Weight')

##Goal1 - Actors as nodes, number of acts together as edges
unique_actors <- unique(c(unique(dat$actor_1_name), unique(dat$actor_2_name), unique(dat$actor_3_name)))
unique_actors <- unique_actors[-which(is.na(unique_actors))]
relationship_actors <- as.data.frame(matrix(0, length(unique_actors), length(unique_actors)))
colnames(relationship_actors) <- unique_actors
rownames(relationship_actors) <- unique_actors

all_actors <- unite(as.data.frame(cbind(dat$actor_1_name, dat$actor_2_name, dat$actor_3_name)))

for(i in 1:length(unique_actors)){ for(j in 1:length(unique_actors)){
  if(j <= i){next()}
  relationship_actors[i, j] <- sum(grep(unique_actors[i], all_actors[,1]) %in% grep(unique_actors[j], all_actors[,1]))
  }
}


##Goal2 - Actors as nodes, average IMDB rating as edges

##Goal3 - Movies as nodes, if common actor b/t them then edge