library(sf) # Biblioteca para trabalhar com shapefile
library(raster) # para trabalhar com raster

# diretorio local dos dados
dir <- "G:\\Meu Drive\\Drive\\Aulas\\Algoritmos\\Aulas2020_1remoto\\dados\\espacial\\"

# importar shapefile
pts <- st_read(paste(dir, "eucalipto_pts.shp", sep = ""))
plot(fc)
# importar shapefile
pol <- st_read(paste(dir, "eucalipto_pol.shp", sep = ""))
plot(pol)
# importar raster
r <- raster(paste(dir, "ndvi.tif", sep = ""))
plot(r)
pts$ndvi <- extract(r, pts)

# modelo exponencial: y = exp(a - b/x)
set.seed(1)
pts$vol <- exp(6.4 - 0.6 / pts$ndvi) + rnorm(length(pts$ndvi), sd = 30*pts$ndvi) 
plot(pts$ndvi, pts$vol)
