### Hemofilia A Adquirida
## Inspiration
No sabíamos gran cosa de clustering así que dijimos, ¿qué algoritmo conocemos? K-means. Y pensamos una manera de aplicarlo a este contexto.
## What it does
A cada paciente le asocia unas coordenadas por cada gen de la siguiente forma. Primero, sumamos las gravedades de cada mutación para cada gen, y después a ese valor lo multiplicamos por la incidencia del gen en el total de los pacientes. Tras aplicar K-means, buscamos grupos de genes que no sean comunes a los cinco centroides, que simbolizan el paciente promedio de cada cluster. Para ello calculamos para cada gen la media de su coordenada en los cinco centros y le sumamos y restamos las desviación típica multiplicada por 1.75. Si el gen queda fuera de ese intervalo, es porque su incidencia en ese cluster es diferente a los demás. De este modo, nos quedamos con los genes de cada cluster que no son comunes al resto.
## How I built it
Primero utilizamos R para calcular la suma de las gravedades de cada gen. Después, con un programa en c++ cambiamos el formato de la base de datos para hacerlo más fácil de manejar. Por último, de nuevo en R multiplicamos por la incidencia y hacemos K-means. También hay otro programa en python para poder visualizar los clusters aplicando un PCA a los datos.
## Challenges I ran into
Los datos estaban completamente codificados y no podíamos interpretarlos de ninguna de las maneras. Además, no había grupo de control para comparar, todos los pacientes estaban enfermos. Y encima, los valores numéricos habían sido convertido a categóricos y una columna que podría dar insight porque eran proteínas, también estaba codificado y no podíamos interpretarlo.
## Accomplishments that I'm proud of
Haber aprendido a modificar y trabajar de forma fluida con un dataset en R.
## What I learned
Utilizar un algoritmo de clustering que a priori no parecía aplicar al problema porque parecía que solo había un grupo importante, pero modificando el objetivo se pudieron encontrar varios grupos.
## What's next for Hemofilia A adquirida
Descodificar el grupo de genes encontrados y analizar si pueden formar parte de una misma cascada biológica.
