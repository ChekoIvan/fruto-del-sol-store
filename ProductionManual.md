### Pasos depués de la instalación en el servidor

Durante el deployment con capistrano, se ejecutan automáticamente las migraciones. Queda por realizar la ejecución de los seeds.

Se debe agregar el usuario administrador del sistema para poder realizar los ajustes y tener la tienda lista.

Desde la terminal nos conectamos al server, y dentro de la carpeta donde se cargó nuestro sistema (/path-to-folder/current/) ejecutamos:
(Crea datos de Spree, usuario administrador y tienda estandar)

> rake RAILS_ENV=production db:seed

Rellenamos con los datos de correo y contraseña y ya podrémos acceder con esas credenciales al sistema.


Las configuraciones previas al despliegue ya se debieron haber realizado en el archivo application.rb
donde se estableció:
* spree.rb
    * Idioma de la aplicación por defecto.
    * Moneda por defecto.

* application.rb
    * Zona Horaria.
    * Acceso cors a la API

--- 

####Configuraciones a realizar en el panel de administrador:
- [ ] Configuración de moneda por defecto
- [ ] Crear la tienda o editar la que viene por defecto.
- [ ] Asignar la tienda por defecto
- [ ] Declarar la categoría o categorías para los productos de la tienda.
- [ ] Crear la zona para México
- [ ] Asignar la zona por defecto a la de México

_La mayoría de las configuraciones anteriores ya se implementaron desde el seeds.rb_

* Crear productos.
* agregar imagnes
* agregar localización de stock
* agregar stock