### Pasos depués de la instalación

Se debe agregar el usuario administrador del sistema para poder realizar los ajustes y tener la tienda lista

Desde la terminal nos conectamos al server, y dentro de la carpeta donde se cargó nuestro sistem ejecutamos:

>RAILS_ENV=production rake spree_auth:admin:create

Rellenamos con los datos de correo y contraseña y ya podrémos acceder con esas credenciales al sistema.

>

Las configuraciones previas al despliegue ya se debieron haber realizado en el archivo application.rb
donde se estableció:
* spree.rb
    * Idioma de la aplicación por defecto.
    * Moneda por defecto.

* application.rb
    * Zona Horaria.
    * Acceso cors a la API

--- 
Configuraciones a realizar como administrador:
[ ] Configuración de moneda por defecto
[ ] Crear la tienda o editar la que viene por defecto.
[ ] Asignar la tienda por defecto
* Declarar la categoría o categorías para los productos de la tienda.
[ ] Crear la zona para México
[ ] Asignar la zona por defecto a la de México

* Crear productos.
* agregar imagnes
* agregar localización de stock
* agregar stock