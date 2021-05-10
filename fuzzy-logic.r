# Importamos librerías
rm(list=ls())
install.packages("FuzzyR")
library(FuzzyR)
 
# Iniciamos un nuevo objeto FIS (Fuzzy inference system)
etapa <- newfis("Variables")
 
# Creamos variables de ingreso con sus rangos
etapa <- addvar(etapa, "input", "edad", c(0,60))
etapa <- addvar(etapa, "input", "salario", c(0,1000))
etapa <- addvar(etapa, "input", "ingreso", c(2000,2021))
etapa <- addvar(etapa, "output", "apellidos", c(0,3))
 
# Creamos funciones de pertenencia trapezoidales y triangulares (inputs)
# Funciones "edad"
etapa <- addmf(etapa,"input", 1, "Joven", "trapmf", c(0,0,25,35) )
etapa <- addmf(etapa,"input", 1, "Adulto", "trimf", c(25,35,45))
etapa <- addmf(etapa,"input", 1, "Viejo", "trapmf", c(35,45,100,100) )
 
# Funciones "salario"
etapa <- addmf(etapa,"input", 2, "Bajo", "trapmf", c(0,0,400,650) )
etapa <- addmf(etapa,"input", 2, "Medio", "trimf", c(400,650,700))
etapa <- addmf(etapa,"input", 2, "Alto", "trapmf", c(650,700,1000,1000) )
 
# Funciones "ingreso"
etapa <- addmf(etapa,"input", 3, "Antiguo", "trapmf", c(0,0,2005,2011) )
etapa <- addmf(etapa,"input", 3, "Medio", "trimf", c(2005,2011,2014))
etapa <- addmf(etapa,"input", 3, "Reciente", "trapmf", c(2011,2014,2021,2021) )
 
# Funciones "cumple requisitos" (output)
etapa <- addmf(etapa,"output", 1, "no cumple requisitos", "trapmf", c(0,0,1,2) )
etapa <- addmf(etapa,"output", 1, "cumple requisitos", "trapmf", c(1,2,3,3))
 
# Dibujamos las funciones
plotmf(etapa,"input",1,xlab="Edad",ylab="Pertenencia",main="Edad")
plotmf(etapa,"input",2,xlab="Salario",ylab="Pertenencia",main="Dinero")
plotmf(etapa,"input",3,xlab="Antigüedad",ylab="Pertenencia",main="Ingreso")
plotmf(etapa,"output",1)
 
# Creamos las reglas que indican qué valor resulta para valores que se encuentren
# en cierto punto de las funciones de pertenencia, respondiendo a la pregunta
# “Cuáles son los apellidos de las personas jóvenes o recientemente empleadas,
# pero con sueldo alto”.
rulelist <- rbind(c(1,3,3,3,1,1),
                  c(1,3,2,2,1,1),
                  c(1,3,1,2,1,1),
 
                  c(2,3,3,2,1,1),
                  c(2,3,2,1,1,1),
                  c(2,3,1,1,1,1),
 
                  c(3,3,3,2,1,1),
                  c(3,3,2,1,1,1),
                  c(3,3,1,1,1,1)
        )
 
# Agregamos reglas al sistema difuso
etapa <- addrule(etapa, rulelist)
 
# Ingresamos valores a evaluar, que son los incluídos en la tabla del enunciado
matrixInput <- matrix(c(30,800,2010, 
                        30,600,2010, 
                        25,900,2004,
                        55,700,2016,
                        25,750,2015),ncol=3, byrow=TRUE) 
 
# Realizamos la evaluación de los inputs usando el sistema difuso y sus resultados
# son entregados en la consola de R.
evalfis(matrixInput,etapa)