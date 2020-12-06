###-------------------------------------###
###----- Gerador de amostras -----------###
###-------------------------------------###

# importar pacotes necessários
#install.packages("sf")
library(sf)
library(ggplot2)
# 1. Importar feição espacial
in_shape <- "G:\\Meu Drive\\Drive\\Aulas\\Algoritmos\\Aulas2020_1remoto\\dados\\espacial\\talhao_florestal.shp"
pol <- st_read(in_shape)
pol
plot(pol["talhao"])

# 2. Determinar a quantidade amostras
# intensidade amostral de 1,5
inten <- 1.5
sum(pol$area_ha)
st_area(pol)
# units::set_units(st_area(pol), "ha")
#pol$area_ha <- st_area(pol) / 10000
area_total <- sum(pol$area_ha)
n_parc <- ceiling(area_total / inten)

# 3. Determinar região permitida para amostras
# Evitar lançamento nas bordas
pol_buf <- st_buffer(pol, dist = -20)
plot(pol_buf["talhao"])
g <- ggplot() +
   geom_sf(data = pol) +
   geom_sf(data = pol_buf, fill = "green")
   
g

# 4. Lançar as amostras na área
pts_sist <- st_sample(pol_buf, size = n_parc, type = "regular")
#length(pts_sist)

# 5. Avaliar a quantidade e garantir a quantidade necessária
cont <- 1
while (length(pts_sist) != n_parc) {
   pts_sist <- st_sample(pol_buf, size = n_parc, type = "regular")
   cat(cont, ":", length(pts_sist), "\n")
   cont <- cont + 1
}

# plotar amostras
length(pts_sist)
g <- ggplot() +
   geom_sf(data = pol) +
   geom_sf(data = pol_buf, fill = "green") +
   geom_sf(data = pts_sist)

g

# 6. Exportar a feição de amostras
id <- paste0("P", 1:length(pts_sist) )#, sep = "")
pts_sist <- st_sf(data.frame(id = id, geom = pts_sist))
out_shape <- "G:\\Meu Drive\\Drive\\Aulas\\Algoritmos\\Aulas2020_1remoto\\dados\\espacial\\parc_florestal.shp"
st_write(pts_sist, out_shape)