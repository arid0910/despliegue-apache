# Usa una imagen base ligera de Node.js, adecuada para aplicaciones en producción.
FROM node:18-alpine

# Establece el directorio de trabajo dentro del contenedor.
WORKDIR /app

# Copia los archivos de configuración de dependencias (package.json y package-lock.json) al contenedor.
COPY package*.json ./

# Instala las dependencias de la aplicación.
RUN npm install

# Copia todos los archivos del proyecto al contenedor.
COPY . .

# Compila la aplicación React para producción, generando el contenido estático en la carpeta 'build'.
RUN npm run build

# Cambia a una imagen base ligera de Nginx para servir archivos estáticos.
FROM nginx:stable-alpine

# Copia los archivos compilados de la carpeta 'build' al directorio donde Nginx sirve los archivos estáticos.
COPY --from=0 /app/build /usr/share/nginx/html

# Expone el puerto 80 para permitir el acceso HTTP al contenedor.
EXPOSE 80

# Inicia Nginx como servidor web principal.
CMD ["nginx", "-g", "daemon off;"]


