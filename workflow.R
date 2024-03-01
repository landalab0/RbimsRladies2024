
#Instalación de librerias

install.packages("devtools")
library(devtools)
install.packages("tidyverse")
library(tidyverse)
library(tidyr)
install_github("mirnavazquez/RbiMs", force = T)
library(rbims)
library(readxl)

#Explorando el metabolismo de la base de datos Interpro --------------------####
#(recuperando los datos de Pfam): 

interpro_PFAMs_profile_T<-read_interpro(data_interpro = "Datos/Interpro/", 
                                        database="Pfam", profile = T) 

#El perfil puede visualizarse en un formato mas extenso:

interpro_PFAMs_profile_F<-read_interpro(data_interpro = "Datos/Interpro/", 
                                       database="Pfam", profile = F) 

#Obtenemos las familias mas importantes. La función PCA.

important_PFAMs_ind<-get_subset_pca(tibble_rbims=interpro_PFAMs_profile_T, 
                                cos2_val=0.98,
                                analysis="Pfam",
                                pca = "Individual")

#Graficando: Heatmap (argumento de distancia = T)

plot_heatmap(important_PFAMs_ind, 
             y_axis=Pfam, 
             analysis = "INTERPRO",
             scale_option = "none",
             distance = T)

#(argumento de distancia = F)

plot_heatmap(important_PFAMs_ind, 
             y_axis=Pfam, 
             analysis= "INTERPRO",
             scale_option = "none",
             distance = F)

#Graficando: Plot bubble
metadata <- read_xlsx("meta.xlsx")

plot_bubble(important_PFAMs_ind, 
            y_axis=Pfam, 
            x_axis=Bin_name, 
            calc = "Binary",
            analysis = "INTERPRO", 
            data_experiment = metadata, 
            color_character = Bin_name)


#Tambien podemos extraer los datos de abundancuas para los IDs de Interpro 
#y explorar rutas específicas


interpro_INTERPRO_profile<-read_interpro(data_interpro = 
                                           "Datos/Interpro/", 
                                         database="INTERPRO", profile = T)

#Nos interesan las abundancias de familias especificas de proteínas 
#para la degradacion de hidrocarburos. Supongamos que conocemos los IDs entonces 
#creamos un vector con los IDs específicos. 


alkane_degradation <- c("IPR033885", "IPR048133","IPR012078","IPR003430")

alkane_INTERPRO<-get_subset_pathway(interpro_INTERPRO_profile, 
                                    type_of_interest_feature=INTERPRO,
                                    interest_feature=alkane_degradation)
head(alkane_INTERPRO)

#Graficamos con plot bubble para observar los datos, podemos agregar nuestros metadatos

plot_bubble(alkane_INTERPRO, 
            y_axis=INTERPRO,
            x_axis=Bin_name,
            analysis = "INTERPRO", 
            calc = "Abundance",
            data_experiment = metadata, 
            color_character = Sample_site)

# Leyendo nuestros datos provenientes de KEGG ------------------------------####

ko_table<-read_ko(data_kofam ="Datos/KEGG/") 
 
# Mapeamos la base de datos oficial de KEGG con nuestros datos

ko_mapp<-mapping_ko(ko_table)

# Leemos metadatos

metadata<-read_excel("meta.xlsx") 

#EL SUBSET DE RUTAS METABÓLICAS

Overview<-c("Naphthalene degradation","Carbon fixation", 
            "Methane metabolism")


Energy_metabolisms<-ko_mapp %>%
  drop_na(Cycle) %>%
  get_subset_pathway(Cycle, Overview) 

#Graficando: plot bubble

plot_bubble(tibble_ko = Energy_metabolisms,
            x_axis = Bin_name,
            y_axis = Genes,
            analysis="KEGG",
            calc="Abundance",
            data_experiment = metadata,
            color_character = order,
            range_size = c(2,10),
            y_labs=FALSE,
            x_labs=FALSE)  

#Graficando heatmap

plot_heatmap(tibble_ko=Energy_metabolisms, 
             y_axis = Pathway_cycle,
             data_experiment = metadata,
             order_y = Cycle,
             order_x = order,
             split_y = T,
             analysis = "KEGG",
             scale_option = "column",
             calc="Abundance")

#Ejemplo con una sola vía

policyclic_aromatic_degradation <- c("map00624")  

hydrocarbon_degradation <- ko_mapp %>%
  drop_na (Pathway) %>%
  get_subset_pathway(Pathway, policyclic_aromatic_degradation)

#Graficamos

plot_bubble(tibble_ko = hydrocarbon_degradation,
            x_axis = Bin_name,
            y_axis = KO,
            analysis="KEGG",
            calc="Abundance",
            data_experiment = metadata,
            color_character = order,
            range_size = c(1,10),
            y_labs=FALSE,
            x_labs=FALSE)  

#heatmap

plot_heatmap(tibble_ko=hydrocarbon_degradation, 
             y_axis = KO,
             data_experiment = metadata,
             order_y = Module,
             order_x = order,
             split_y = T,
             analysis = "KEGG",
             #scale_option = "row",
             calc="Abundance")


#Explore metabolism for dbCAN-----------------------------------------------####

#(recuperando los datos de las familias de enzimas): 

dbcan_FAMs_profile_T<-read_dbcan3(dbcan_path = "Datos/dbCAN/", profile = T) 

#El perfil puede visualizarse en un formato mas extenso:

dbcan_FAMs_profile_F<-read_dbcan3(dbcan_path = "Datos/dbCAN/",  profile = F) 

#Obtenemos las familias mas importantes. La función PCA.

important_dbcanFAMs<-get_subset_pca(tibble_rbims=dbcan_FAMs_profile_T, 
                                    cos2_val=0.98,
                                    analysis= "dbCAN",
                                    pca = "Both")

#Graficando: Heatmap (argumento de distancia = T)

plot_heatmap(important_dbcanFAMs, 
             y_axis = dbCAN_fam, 
             analysis = "dbCAN",
             scale_option = "none",
             distance = T)

#(argumento de distancia = F)

plot_heatmap(important_dbcanFAMs, 
             y_axis= dbCAN_fam, 
             analysis= "dbCAN",
             scale_option = "none",
             distance = F)

#Graficando: Plot bubble
metadata <- read_xlsx("meta.xlsx")

plot_bubble(important_dbcanFAMs, 
            y_axis=dbCAN_fam, 
            x_axis=Bin_name, 
            calc = "Abundance",
            analysis = "dbCAN", 
            data_experiment = metadata, 
            color_character = Bin_name)

