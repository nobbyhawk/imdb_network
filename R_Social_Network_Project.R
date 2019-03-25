library(readr)
library(tidyr)
library(igraph)
#dat <- read_csv('C:\\Users\\lasky\\Google Drive\\Graduate School _ Jobs\\NCSU MSA\\Personal Projects\\IMDB Network Analysis\\imdb_network\\movie_metadata.csv')

#colnames(dat)
#dat <- dat[,-1]
##columns need to be
gephi_col_names <- c('Source', 'Target', 'Type', 'Id', 'Label', 'Interval', 'Weight')

##Goal1 - Actors as nodes, number of acts together as edges
###below is too slow, using top 250 instead
# unique_actors <- unique(c(unique(dat$actor_1_name), unique(dat$actor_2_name), unique(dat$actor_3_name)))
# unique_actors <- unique_actors[-which(is.na(unique_actors))]
# relationship_actors <- as.data.frame(matrix(0, length(unique_actors), length(unique_actors)))
# colnames(relationship_actors) <- unique_actors
# rownames(relationship_actors) <- unique_actors
# 
# all_actors <- unite(as.data.frame(cbind(dat$actor_1_name, dat$actor_2_name, dat$actor_3_name)))
# 
# for(i in 1:length(unique_actors)){ for(j in 1:length(unique_actors)){
#   if(j <= i){next()}
#   relationship_actors[i, j] <- sum(grep(unique_actors[i], all_actors[,1]) %in% grep(unique_actors[j], all_actors[,1]))
#   }
# }

dat <- read.csv('C:\\Users\\lasky\\Google Drive\\Graduate School _ Jobs\\NCSU MSA\\Personal Projects\\IMDB Network Analysis\\imdb_network\\Top_250.csv', header = FALSE, col.names = c('Actor1', 'Actor2', 'Actor3'), sep = ';')
dat <- dat[-170,]
cols12 <- as.data.frame(table(dat[,c(1,2)]))[which(as.data.frame(table(dat[,c(1,2)]))[,3]!=0),]
cols23 <- as.data.frame(table(dat[,c(2,3)]))[which(as.data.frame(table(dat[,c(2,3)]))[,3]!=0),]
cols13 <- as.data.frame(table(dat[,c(1,3)]))[which(as.data.frame(table(dat[,c(1,3)]))[,3]!=0),]
colnames(cols12) <- c('Source', 'Target', 'Weight')
colnames(cols23) <- c('Source', 'Target', 'Weight')
colnames(cols13) <- c('Source', 'Target', 'Weight')
all.vals <- rbind(cols12, cols13, cols23)
gephi_csv <- as.data.frame(matrix(NA, nrow = nrow(all.vals), ncol = length(gephi_col_names)))
colnames(gephi_csv) <- gephi_col_names
gephi_csv[,c(1,2,5,7)] <- all.vals[,c(1,2,1,3)]
gephi_csv[,3] <- 'Undirected'
gephi_csv[,4] <- 0:(nrow(all.vals)-1)
write.csv(x = gephi_csv, file = 'C:\\Users\\lasky\\Google Drive\\Graduate School _ Jobs\\NCSU MSA\\Personal Projects\\IMDB Network Analysis\\imdb_network\\manual_csv.csv')



##Goal2 - Actors as nodes, average IMDB rating as edges

##Goal3 - Movies as nodes, if common actor b/t them then edge