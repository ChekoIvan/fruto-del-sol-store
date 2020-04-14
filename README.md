# README

Proyecto de tienda en línea para Fruto del Sol

* Ruby: **2.6.5**

* Rails: **6.0.2**

## Pasos a seguir.

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
    >