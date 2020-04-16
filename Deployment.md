#CONFIGURACIÓN PARA DEPLOYMENT DE APLICACION CON RAILS - APACHE - PASSENGER - CENTOS 7

Lo aconsejable sería tener el acceso por ssh.
https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-centos7
Además, se tendrá que generar una key para conectarse al repo en github.

La recomendación es tener un usuario del sistema específico para el deploy
>adduser deploy
>passwd deploy
>gpasswd -a deploy wheel

Desde la maquina remota
Generamos una ssh key, o si ya la tenemos solo la copiamos

>ssh-copy deploy@206.189.180.213

De nuevo en el server

##Instalación de Ruby y Rails 
>sudo yum update

###AHORA INSTALAMOS RUBY CON RBENV
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-centos-7

>sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel

>cd

>git clone git://github.com/sstephenson/rbenv.git .rbenv
>echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
>echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

>git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
>echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
>exec $SHELL

**Cerrar la shell y reabrir si no detecta el cambio en el path**

Instalamos la versión de ruby y cuando termine la ajustamos a que sea la versión default
>rbenv install -v 2.6.5
rbenv global 2.6.5
ruby -v

Agregamos la configuración para no instalar la documentación de las gemas
>echo "gem: --no-document" > ~/.gemrc

Instalamos 
>gem install bundler
gem install rails
rbenv rehash
rails -v

###Instalamos nuestro gestor de base de datos 
https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-centos-7

#### Instalamos las gema del gestor

>gem install mysql2

###Instalamos node en la versión más reciente ~12
<!-- (Esta primer opción no la recomendamos, porque si necesitamos yarn, yum no resuelve la depenencia a node.)
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-a-centos-7-server

Bajamos los binarios de
wget https://nodejs.org/dist/v12.16.2/node-v12.16.2-linux-x64.tar.xz
sudo tar --strip-components 1 -xvf node-v12.16.2-linux-x64.tar.xz -C /usr/local/
node --version

En este se indica el método optimo -->
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-centos-7

>curl -L -o nodesource_setup.sh https://rpm.nodesource.com/setup_12.x
sudo -E bash nodesource_setup.sh
sudo yum clean all
sudo yum makecache fast
sudo yum install -y gcc-c++ make
sudo yum install -y nodejs
node -v

#### Instalamos Yarn
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install yarn

#### Instalamos apache y passenger
https://www.phusionpassenger.com/library/install/apache/install/oss/el7/

>sudo yum install -y epel-release yum-utils
sudo yum-config-manager --enable epel
sudo yum clean all && sudo yum update -y

>sudo yum update -y

Verificar la fecha del servidor
>date

Dependencias de passenger
>sudo yum install -y pygpgme curl

Agregamos el repo
>sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo

Instalamos passenger
>sudo yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yum install -y mod_passenger

Reiniciamos apache
>sudo systemctl restart httpd

Ejecutamos la herramienta de validación de la instalacion de passenger
>sudo /usr/bin/passenger-config validate-install

Si arroja la falta de la librería para verificar apache la instalamos
>sudo yum install httpd-devel


Como proceso adicional se puede configurar la ubicación de los binarios de ruby a utilizar por passenger.
>passenger-config --ruby-command

Ese comando indica la línea a pegar en el archivo de configuración de passenger, ubicado en /etc/httpd/conf.d/passenger.conf

```
<IfModule mod_passenger.c>
   PassengerRoot /usr/share/ruby/vendor_ruby/phusion_passenger/locations.ini
#  PassengerRuby /usr/bin/ruby
   PassengerRuby /home/deploy/.rbenv/versions/2.6.5/bin/ruby
   PassengerInstanceRegistryDir /var/run/passenger-instreg
</IfModule>
```
Info:
https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerruby

Si no está configurado el directorio temporal de registro de passenger, se tiene que añadir su configuración

https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerinstanceregistrydir
(Información obtenida de  https://github.com/phusion/passenger/issues/2209)

La configuración que cargó la instalación puede ser obtenida con 
>passenger-config --snippet

El servidor web debe seguir mostrando la página web por default, o las configuraciones ya cargadas

####Configuración básica de virtual host para el apache.
```
<VirtualHost *:80>
      ServerName www.frutodelsol.com
       # Be sure to point to 'public'!
      DocumentRoot /home/deploy/fruto-del-sol-store/current/public
      <Directory /home/deploy/fruto-del-sol-store/current/public>
         # Relax Apache security settings
         AllowOverride all
         Require all granted
         # MultiViews must be turned off
         Options -MultiViews
      </Directory>
</VirtualHost>

```
___
###CONFIGURACIÓN DEL PROYECTO A SUBIR AL SERVIDOR con Capistrano.
Como una sugerencia recibida, se puede clonar el repo e instalar todas las dependencias y gemas en el server, y echarlo a andar, para verificar que no haga falta nada por instalar.

Antes de iniciar con capistrano, debemos crear la base de datos para producción.


1. crear la carpeta donde se copiará el proyecto con capistrano
1. crear las variables de entorno para rbenv
1. Verificar que la conexión a la base de datos se realice correctamente con la cofiguración establecida al archivo enviroments/production.rb  del proyecto.

Ya se pueden seguir tal cual los pasos indicados en la siguiente entrada:

>https://gorails.com/deploy/ubuntu/18.04#capistrano
y desde el minuto 21 del su video. https://www.youtube.com/watch?v=vzEEfAj45zw
(el video trae un caso de error por si se equivoca uno en la versión de ruby)

capistrano indica en la terminal los pasos completados y los errores que impidan la culminación  del deploy. 
una vez depurados los errores, y que capistrano termine, ya se tiene el proyecto desplegado.

---
### Errores despues del despliegue.

#### Si el log y apache muestran el error 403
https://www.phusionpassenger.com/library/admin/apache/troubleshooting/ruby/#apache-cannot-access-my-app-s-files-because-of-selinux-errors

>sudo chcon -R -h -t httpd_sys_content_t /home/deploy/fruto-del-sol-store/

Mas info acerca del tema.
https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-2-files-and-processes


Tambien verificar los permisos normales del sistema, el último detalle de acceso fueron los permisos de "search" en un componente del "path". 
Para el caso fue la carpeta "deploy"
>chmod +x /home/deploy

Referencia General
https://qiita.com/alokrawat050/items/ecd864a098198ebb3537

#### Error con MiniMagick
 MiniMagick::Error (You must have ImageMagick or GraphicsMagick installed):
 solo instalamos la dependecia desde nuestro gestor de packetes. 
 >sudo yum install ImageMagick
 
 
