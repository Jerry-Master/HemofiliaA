library(dplyr)
library(tidyr)

# Read and express data as wanted
BxM <- read.delim("BxM.txt", header=FALSE)
BxM <- BxM[-1,]
# This may give the error: "Error: Evaluation error: ‘sum’ not meaningful for factors."
# Ignore it
BxM$V5 <- as.numeric(BxM$V5)
grav <- BxM %>% group_by(V1, V2) %>% summarise(V5 = sum(V5))
write.table(grav, file="kmeans.txt", quote=F, sep="\t")
# This 2 lines are to compile dataset.cpp and execute it
system("g++ -Wall -O2 -std=c++11 dataset.cpp -o dataset")
system("./dataset")
km <- read.csv("kmeans.csv", header = T, sep=",")
prob.gen <- (BxM %>% group_by(V2) %>% count())$n / 1032190
prob.km <- data.frame(mapply(`*`,km[,2:16769],prob.gen))
prob.km <- prob.km[-39,]

# Look for optimal k for kmeans
withins <- c()
for (i in 2:11){
  clusters <- kmeans(prob.km, i)
  print(clusters$tot.withinss/38)
  withins <- c(withins, clusters$tot.withinss/38)
}
plot(c(2:11), withins, type="l")
# Choose a k
cluster3 <- kmeans(prob.km, 3)
classification <- data.frame(cluster=cluster3$cluster, row.names=levels(BxM$V1)[c(-39,-40)])
write.csv(classification, "classification.csv", quote=F)

# Generate a "confidence" interval
desv <- apply(cluster3$centers, 2, sd)
med <- apply(cluster3$centers, 2, mean)
conf.up <- med + 1.1547*desv

# Get gens out of this interval
gen1 <- cluster3$centers[1,cluster3$centers[1,] > conf.up] %>% names()
gen2 <- cluster3$centers[2,cluster3$centers[2,] > conf.up] %>% names()
gen3 <- cluster3$centers[3,cluster3$centers[3,] > conf.up] %>% names()

# Check that they are disjoint sets
gen1[!(gen1 %in% gen2) && !(gen1 %in% gen3)] %>% length() == length(gen1)
gen2[!(gen2 %in% gen1) && !(gen2 %in% gen3)] %>% length() == length(gen2)
gen3[!(gen3 %in% gen1) && !(gen3 %in% gen2)] %>% length() == length(gen3)

write.csv(gen1, "gen1.csv", quote=F)
write.csv(gen2, "gen2.csv", quote=F)
write.csv(gen3, "gen3.csv", quote=F)
