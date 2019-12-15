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

# Generate a "confidence" interval
desv <- apply(clusters5$centers, 2, sd)
med <- apply(clusters5$centers, 2, mean)
conf.down <- med - 1.75*desv
conf.up <- med + 1.75*desv

# Get gens out of this interval
gen1 <- clusters5$centers[1,clusters5$centers[1,] < conf.down | clusters5$centers[1,] > conf.up] %>% names()
gen2 <- clusters5$centers[2,clusters5$centers[2,] < conf.down | clusters5$centers[2,] > conf.up] %>% names()
gen3 <- clusters5$centers[3,clusters5$centers[3,] < conf.down | clusters5$centers[3,] > conf.up] %>% names()
gen4 <- clusters5$centers[4,clusters5$centers[4,] < conf.down | clusters5$centers[4,] > conf.up] %>% names()
gen5 <- clusters5$centers[5,clusters5$centers[5,] < conf.down | clusters5$centers[5,] > conf.up] %>% names()

# Check that they are disjoint sets
gen1[!(gen1 %in% gen2) && !(gen1 %in% gen3) && !(gen1 %in% gen4) && !(gen1 %in% gen5)] %>% length() == length(gen1)
gen2[!(gen2 %in% gen1) && !(gen2 %in% gen3) && !(gen2 %in% gen4) && !(gen2 %in% gen5)] %>% length() == length(gen2)
gen3[!(gen3 %in% gen1) && !(gen3 %in% gen2) && !(gen3 %in% gen4) && !(gen3 %in% gen5)] %>% length() == length(gen3)
gen4[!(gen4 %in% gen1) && !(gen4 %in% gen2) && !(gen4 %in% gen3) && !(gen4 %in% gen5)] %>% length() == length(gen4)
gen5[!(gen5 %in% gen1) && !(gen5 %in% gen2) && !(gen5 %in% gen3) && !(gen5 %in% gen4)] %>% length() == length(gen5)

write.csv(gen1, "gen1.csv")
write.csv(gen2, "gen2.csv")
write.csv(gen3, "gen3.csv")
write.csv(gen4, "gen4.csv")
write.csv(gen5, "gen5.csv")
