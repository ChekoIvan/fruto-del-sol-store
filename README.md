# README

Proyecto de tienda en línea para Fruto del Sol

* Ruby: **2.6.5**

* Rails: **6.0.2**

## Pasos realizados para el actual repositorio.

1. Tener una instalación de Rails funcionando, con la versión indicada

1. Crear la base de datos
    > rake db:create
1. Añadir las siguientes gemas al Gemfile
    >gem 'spree', '~> 4.1'
    >gem 'spree_auth_devise', '~> 4.1'
    >gem 'spree_gateway', '~> 3.7'
1. Instalarlas gemas desde bundle
    >bundle install
1. Correr la configuración de Spree para controladores y migraciones ( sin los datos de prueba)
    >rails g spree:install --user_class=Spree::User --sample=false
    >
    >rails g spree:auth:install
    >
    >rails g spree_gateway:install

        Hasta este punto, el sistema tiene la estructura por defecto, se agregaron gran catidad de archivos en los assets y en las migraciones.
1. Para traerse al directorio actual las views del Panel de Administrador, las copiamos con su generador
    >rails g spree:backend:copy_views
        Tiene conflicto con 5 archivos de vistas para paginación, porque ya existen. De ahí se copian 
1. Cambio de lenguaje al backend, Spree tiene su opción multilenguaje en otro repositorio con una gema para automatizar el cambio. En el Gemfile se agrega:
    >gem 'spree_i18n', github: 'spree-contrib/spree_i18n'
1. Se instala
    >bundle install
1. Se copian y corren las migraciones
    >bundle exec rails g spree_i18n:install
    
1. Agregar Paypal
    >gem 'spree_paypal_express', github: 'spree-contrib/better_spree_paypal_express'
1. Sus migraciones
    >bundle exec rails g spree_paypal_express:install

1. Agregar panel de configuración de SMTP, añadimos la gema spree_mail_settings al Gemfile

    >gem 'spree_mail_settings', github: 'ChekoIvan/spree_mail_settings', branch: 'master'

    >bundle install

1. Agregar el sdk de Mercado pago
    >gem 'mercadopago-sdk'

    Los archivos actualmente necesarios se integraron manualmente al repo

1. Habilitar cors para uso de la api.(Opcional)
    >gem 'rack-cors'
    
    Agregar en application.rb la configuración necesaria. (ejemplo:)

       config.middleware.insert_before 0, Rack::Cors do
         allow do
           origins '*'
           resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
         end
       end

**En resumen, estas son las dependencias de Spree y agregados para tener una tienda lista.**

Ya se debió correr las migraciones a este punto. En caso que se inicie con el repo ya completo, se ejecutan.
> rake db:migrate

Para introducir los datos básicos, se agregó al Seeds.rb un set de información estandar. Así que solo se ejecuta el seed a la base. Esto ejecutará los seeders que spree necesita como mínimo. en los cuales pide la creación de un usuario administrador, el cual será solicitado en la consola.
Posterior a eso, se agregó al archivo la información básica de una tienda. (Para modificar los datos de la tienda, se puede realizar los ajustes necesarios en el archivo Seeds.rb).

> rake db:seed

##Ajustes 

El primer set de ajustes se realiza en los archivos del proyecto.

**application.rb**, ahi se declaran cosas como: el [loader de clases de ruby](https://medium.com/cedarcode/understanding-zeitwerk-in-rails-6-f168a9f09a1f). La zona horaria, los locales preferidos. _Estos ajustes están declarados en este archivo debido a que spree sigue las convenciones utilizadas por Rails, asi que al ser "globales" se "pasan" a los módulos de Spree automáticamente._

    config.load_defaults 6.0
    config.time_zone = 'Mexico City'
    config.i18n.available_locales = [:en, :'es-MX']
    config.i18n.default_locale = :'es-MX'
    config.i18n.locale = :'es-MX'

**spree.rb**, este archivo ubicado en la carpeta de initializers, contiene configuración utilizada directamente en la tienda como los logotipos a mostrar (tienda y admin panel), mostrar la versión de spree en el panel de administrador. Y el código de moneda a utilizar por defecto en la tienda.

    config.logo = 'logos/logo_h.png'
    config.admin_interface_logo = 'logos/logo33_h.png'
    config.admin_show_version = false
    config.currency = 'MXN'


**Iniciamos el server** (development)
    
   > rails s

Una vez con los datos iniciales, se empiezan a introducir las configuraciones desde el sistema, accediendo con el usuario administrador creado.

Se configuran cosas como:
* Configuración general 
    * Verificar que la moneda global esté en MXN
    * Idimas disponibles para el front (No disponible en el frontend actual. )
* Tiendas
    * Seleccionar la tienda por defecto
    * Verificar que la moneda asignada a la tienda corresponda a la global
    * Los datos de la tienda sean correctos.
* [Métodos de envío](https://guides.spreecommerce.org/user/payments/payment_methods.html)
    * Revisar que los métodos de envío sean los disponibles.
* [Métodos de pago](https://guides.spreecommerce.org/user/payments/payment_methods.html), en cada uno se agrega y posteriormente se introducen las claves de acceso solicitadas.
    * Agregar los métodos de pago
    * Agregar Paypal Express
    * Agregar Mercado Pago
    * Agregar Stripe
*  Todas las ubicaciones de inventario
    * Es obligatorio tener mínimo una ubicación para poder tener stock de productos.
* Preferencias Métodos de email, esta configuración sobreescribe cualquier configuración dada en los archivos application.rb o #{enviroment}.rb
    * Se establece la configuración del servidor SMTP a utilizar. 


---
En este punto, las configuraciones son las suficientes para poder empezar a agregar productos.

El [manual de Spree](https://guides.spreecommerce.org/user/products/) ejemplifica este proceso.