# Read and express data as wanted
BxM <- read.delim("~/BxM.txt", header=FALSE)
BxM <- BxM[-1,]
grav <- BxM %>% group_by(V1, V2) %>% summarise(V5 = sum(V5))
km <- read.csv(kmeans.csv, header = T, sep=",")
prob.gen <- (BxM %>% group_by(V2) %>% count())$n / 1032190
prob.km <- data.frame(mapply(`*`,km[,2:16769],prob.gen))

# Look for optimal k for kmeans
withins <- c()
for (i in 2:11){
  clusters <- kmeans(prob.km, i)
  print(sum(clusters$withinss)/39)
  withins <- c(withins, sum(clusters$withinss)/39)
}
plot(c(2:11), withins, type="l")
# Choose a k
cluster3 <- kmeans(prob.km, 3)

# Generate a "confidence" interval
desv <- apply(clusters3$centers, 2, sd)
med <- apply(clusters3$centers, 2, mean)
conf.down <- med - 1.1547*desv
conf.up <- med + 1.1547*desv

# Get gens out of this interval
gen1 <- clusters3$centers[1,clusters3$centers[1,] < conf.down | clusters3$centers[1,] > conf.up] %>% names()
gen2 <- clusters3$centers[2,clusters3$centers[2,] < conf.down | clusters3$centers[2,] > conf.up] %>% names()
gen3 <- clusters3$centers[3,clusters3$centers[3,] < conf.down | clusters3$centers[3,] > conf.up] %>% names()

# Check that they are disjoint sets
gen1[!(gen1 %in% gen2) && !(gen1 %in% gen3)] %>% length() == length(gen1)
gen2[!(gen2 %in% gen1) && !(gen2 %in% gen3)] %>% length() == length(gen2)
gen3[!(gen3 %in% gen1) && !(gen3 %in% gen2)] %>% length() == length(gen3)

write.csv(gen1, "gen1.csv", quote=F)
write.csv(gen2, "gen2.csv", quote=F)
write.csv(gen3, "gen3.csv", quote=F)
