# Usa la imagen base de node con Alpine
FROM node:11.1.0-alpine

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia los archivos de configuración (package.json y package-lock.json) e instala las dependencias
COPY package*.json ./
RUN apk add --no-cache npm   # Instala npm
RUN npm install

# Expone el puerto 3000
EXPOSE 3000

# Copia el resto de la aplicación
COPY . .

# Comando para ejecutar la aplicación
CMD ["node", "index"]

