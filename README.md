billing
=======

The schema of this module is oriented more toward compatibility with Fiscal Memory Devices, rather than Accounting Software, but it incorporates base Billing and Invoicing standards.  
It is suitable for use in Trading Software, Online Shops and provides UFB (Universal Fiscal Basket) for issuing fiscal receipts with [Extface](https://github.com/AlexVangelov/extface) module.

*This module is currently in development stage*

## The idea

Bill text constructor protocol:

    *1                (set operator 1)  
    1.2               (charge $1.2)   / default currency or $, default tax group
    1.2               (charge $1.2)
    2*4,5             (2 charges $4.5)
    1.2@2             (charge $1.2, tax group 2)
    1.2/text          (charge $1.2 with text)
    /text             (zero charge with text / comment)
    10-50%            (charge $10 with 50% discount)
    20-2              (charge $20, discount $2)
    #23               (charge PLU by number)
    2*#23             (2 qty of PLU by number)
    2.5*#23-20%       (2.5 qty of PLU by number, 20% discount)
    50+2              (charge $50 with $2 surcharge)
    -10%              (discount 10% whole bill)
    -5                (discount $5)
    @2/10             (payment $10 with payment type 2)
    @1                (auto calculated payment with payment type 1 / or default payment type if not specified)
    @#36              (auto calculated payment and issue invoice for profile 36)         

###Charge

    [qty*][price][#PLU][@tax]][+surcharge[%]/-discount[%]][/text]
    
###Discount/Surcharge

    +/-[value[%]][/text]
    
###Payment

    @[type[/value]][#profile]

##Billing schema

Namespace ***Billing***

* **Account** - Base billing class.
* **Charge** - Bill item which increases the total.
* **Modilfier** - Discount or Surcharge for specified item or global. Can be percent or fixed value.
* **Payment** - STI model, that defaults to payment with type. Can be extended to payment by external system or with payment gateway.

Nomenclature (STI models):

* **TaxGroup** - VAT settings
* **PaymentType** - Cash, Fiscal
* **Operator** - Fiscal device users
* **Department** - PLU (Price look-up) groups
* **Plu** - Price look-up items
* **Origin** - Billing source categorization and settings
* **Profile** - Invoice infos


**Instalation

    gem 'billing'

    bundle install
    bundle exec bin/rake billing:install
    bundle exec bin/rake db:migrate
    
###Enable billing for an ActiveRecord model by adding macro-like class method:

    class MyBillableModel < ActiveRecord::Base
      has_billing
    end

The module will add ***#billing_accounts*** collection to the model.

See [http://alexvangelov.wordpress.com/2014/07/20/ruby-on-rails-app-with-billing-and-fiscalization-part1-billing-model/](http://alexvangelov.wordpress.com/2014/07/20/ruby-on-rails-app-with-billing-and-fiscalization-part1-billing-model/)
