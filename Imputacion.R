#paquetes: mice, VIM, missForest,ggplot2,colorspace,dplyr,readr, stringr, tidyverse
#base de datos
data(iris)
data<-iris
summary(iris)


#elimina datos aleatoriamente
seed=123
#valores perdidos (15%)
iris24<-data.frame(prodNA(iris[1:4], noNA = 0.15),iris[5])#esta funcion es de missforest
View(iris24)
View(iris)
summary(iris.mis)


#se retira la categoría species (debido a que no es numérica)
iris.mis=subset(iris24, select = -c(Species))
View(iris.mis)


#gráfico que permite determinar los valores perdidos
md.pattern(iris.mis)

#otro modo de visulización de los datos perdidos
library(VIM)
miceplot=aggr(iris.mis, col=c('navyblue','yellow'),numbers=TRUE, sortVars=TRUE, labels=names(iris.mis),cex.axis=0.7,gap=3, ylab=c('Missing data','Pattern'))
#el color amarillo indica los datos perdidos 

#imputación de datos por ecuaciones concatenadas
imputeddata=mice(iris.mis, method = 'pmm', m=5, maxit = 50, seed=500)
summary(imputeddata) #indica qué variables son usadas para construir la variable dependiente

#m: # de imputaciones múltiples
#maxit: # de iteraciones por imputación
#seed: garantiza la replicabilidad
#method: 'pmm', coincidencia de medias predictivas (numéricos). 'logreg', regresión logística (dicotómicos). Más información en el manual

#comprobar valores imputados para la variable Sepal.Width en las cinco imputaciones
imputeddata$imp$Sepal.Width[1] #el número permite observar los datos de ese número de imputación

# realiza un ajuste lineal para Sepal.Length con las demás cariables en cada una de las 5 imputaciones
fit1 <- with(imputeddata, lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width))
summary(fit1)

# aplica las reglas de Rubin para condensar las 5 iteraciones
pooled_fit <- pool(fit1)
#summary(pooled_fit) #entrega el modelo condensado
pooled_fit
#completando la base de datos con la imputación 4, esto usualmente se elige de forma aleatoria
completa=complete(imputeddata, 4)
completa=as.data.frame(completa) #la vuelve un dataframe
completa

#graficando los datos
Imputados =ifelse(is.na(iris.mis$Sepal.Length + iris.mis$Sepal.Width), "Sí", "No")
Imputados #dataframe que etiqueta los valores como perdidos o no perdidos en el dataframe iris.mis

#concatenando dataframes para graficar
data2=data.frame(completa,Imputados)
data2

#para graficar en diferentes colores dependiendo de si es missing o no
ggplot(data=data2, mapping = aes(x=Sepal.Width, y=Sepal.Length, color=Imputados))+geom_point()

ggplot(data=iris, mapping = aes(x=Sepal.Width, y=Sepal.Length))+geom_point()

#histograma
ggplot(data = data2, mapping = aes(x=Sepal.Width, fill=Imputados))+geom_histogram()+labs(title = 'Imputación MICE')
#histograma original
ggplot(data = iris, mapping = aes(x=Sepal.Width))+geom_histogram()+geom_histogram()+labs(title = 'Original')
#--------------------------------------------------------------------------------------------------------

#imputando por la media por columnas, se debe especificar de este modo ya que solo se hará una vez
imputeddata2=mice(iris.mis, method = 'mean', m=1, maxit = 1)  
summary(imputeddata2)
imputeddata2$imp$Sepal.Width

#comprobando que se trata de imputación por la media
x=c(iris.mis$Sepal.Width) #eligiendo la columna Sepal.Width
x1=na.omit(x) #eliminando NA
mean(x1) #calculando la media

#completando los datos con la media
completa1=complete(imputeddata2, 1)
completa1

#graficando los datos.  
#ESTO SOBRA YA QUE ES EL MISMO DATAFRAME DEFINIDO EN EL PASO ANTERIOR. (Es útil para ejemplificar)
Imputados1 =ifelse(is.na(iris.mis$Sepal.Length + iris.mis$Sepal.Width), "Sí", "No")
Imputados1 #dataframe que etiqueta los valores como perdidos o no perdidos en el dataframe iris.mis

#concatenando dataframes para graficar
data3=data.frame(completa1,Imputados1)
data3

#para graficar en diferentes colores dependiendo de si es missing o no
ggplot(data=data3, mapping = aes(x=Sepal.Width, y=Sepal.Length, color=Imputados))+geom_point()

ggplot(data=iris, mapping = aes(x=Sepal.Width, y=Sepal.Length))+geom_point()

#hitograma condatos imputados
ggplot(data = data3, mapping = aes(x=Sepal.Width, fill=Imputados))+geom_histogram()+labs(title = 'Imputación media')
#histograma original
ggplot(data = iris, mapping = aes(x=Sepal.Width))+geom_histogram()+geom_histogram()+labs(title = 'Original')
#------------------------------------------------------------------------------------------------
#imputadno por regresión lineal múltiple
imputeddata3=mice(iris.mis, method = 'norm.predict', m=1,seed=1)
imputeddata3$imp$Sepal.Width

#completando los datos con la media
completa2=complete(imputeddata3, 1)
completa2

#graficando los datos
#ESTO SOBRA YA QUE ES EL MISMO DATAFRAME DEFINIDO EN EL PASO ANTERIOR. (Es útil para ejemplificar)
Imputa2 =ifelse(is.na(iris.mis$Sepal.Length + iris.mis$Sepal.Width), "Sí", "No")
Imputa2 #dataframe que etiqueta los valores como perdidos o no perdidos en el dataframe iris.mis

#concatenando dataframes para graficar
data4=data.frame(completa2,Imputa2)
data4

#para graficar en diferentes colores dependiendo de si es missing o no
ggplot(data=data4, mapping = aes(x=Sepal.Width, y=Sepal.Length, color=Imputados))+geom_point()

#Regresiones
Regr=lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width, data4)
summary(Regr)#en el r^2 es posible observar que hay una tendencia a fortalecer la relación lineal artificialmente 
Regr1=lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width, iris)
summary(Regr1)

#hitograma condatos imputados
ggplot(data = data4, mapping = aes(x=Sepal.Width, fill=Imputados))+geom_histogram()+labs(title = 'Imputación regresión')
#histograma original
ggplot(data = iris, mapping = aes(x=Sepal.Width))+geom_histogram()+labs(title = 'Original')
#----------------------------------------------------------------------------------
#naniar
gg_miss_var(iris24, facet=Petal.Length, show_pct = TRUE)
