# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

Spree::Store.new do |s|
    s.name                    = 'Fruto del Sol'
    s.code                    = 'frutodelsol'
    s.url                     = Rails.application.routes.default_url_options[:host] || 'www.frutodelsol.com.mx'
    s.mail_from_address       = 'ventas@frutodelsol.com.mx'
    s.default_currency        = 'MXN'
    s.seo_title               = 'Mezcal Fruto del Sol'
    s.meta_description        = 'Mezcal Fruto del Sol'
    s.facebook                = 'https://www.facebook.com/MezcalFrutodelSol'
    s.twitter                 = ''
    s.instagram               = 'https://www.instagram.com/frutodls/'
  end.save!

Spree::TaxCategory.where(name: 'Mezcal').first_or_create!

mexico_zone = Spree::Zone.where(name: 'México', description: 'Territorio Mexicano', kind: 'country').first_or_create!
mexico_state = Spree::Country.find_by!(iso3: 'MEX')
mexico_zone.zone_members.where(zoneable: mexico_state).first_or_create!

Spree::ShippingCategory.find_or_create_by!(name: 'Default')

mexico_zone = Spree::Zone.find_by!(name: 'México')
  
shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'Default')
  
shipping_methods = [
  {
    name: 'Recoger en tienda',
    zones: [mexico_zone],
    display_on: 'both',
    shipping_categories: [shipping_category]
  },
  {
    name: 'FedEx 1 día (MXN)',
    zones: [mexico_zone],
    display_on: 'both',
    shipping_categories: [shipping_category]
  },
  {
    name: 'Estafeta 1 día (MXN)',
    zones: [mexico_zone],
    display_on: 'both',
    shipping_categories: [shipping_category]
  }
]
  
shipping_methods.each do |attributes|
  Spree::ShippingMethod.where(name: attributes[:name]).first_or_create! do |shipping_method|
    shipping_method.calculator = Spree::Calculator::Shipping::FlatRate.create!
    shipping_method.zones = attributes[:zones]
    shipping_method.display_on = attributes[:display_on]
    shipping_method.shipping_categories = attributes[:shipping_categories]
  end
end

{
  'Recoger en tienda' => [0, 'MXN'],
  'FedEx 1 día (MXN)' => [150, 'MXN'],
  'Estafeta 1 día (MXN)' => [90, 'MXN'],
}.each do |shipping_method_name, (price, currency)|
  shipping_method = Spree::ShippingMethod.find_by!(name: shipping_method_name)
  shipping_method.calculator.preferences = {
    amount: price,
    currency: currency
  }
  shipping_method.calculator.save!
  shipping_method.save!
end

country =  Spree::Country.find_by(iso: 'MX')
location = Spree::StockLocation.find_or_create_by!(name: 'default')
location.update_attributes!(
  address1: 'Av. de las Américas N°100-A',
  city: 'Oaxaca',
  zipcode: '68140',
  country: country,
  active: true
)