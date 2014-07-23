billing
=======

The schema of this module is oriented more toward compatibility with Fiscal Memory Devices, rather than Accounting Software, but it incorporates base Billing and Invoicing standards.  
It is suitable for use in Trading Software, Online Shops and provides UFB (Universal Fiscal Basket) for issuing fiscal receipts with [Extface](https://github.com/AlexVangelov/extface) module.

*This module is currently in development stage*

## The idea

Bill text constructor protocol:

    *1                (set operator 1)  
    1.2               (charge $1.2)   / default currency or $, default tax group
    2*4,5             (2 charges $4.5)
    1.2@2             (charge $1.2, tax group 2)
    1.2/text          (charge $1.2 with text)
    /text             (zero charge with text / comment)
    10-50%            (charge $10 with 50% discount)
    20-2              (charge $20, discount $2)
    #23               (charge PLU by number)
    2*#23             (2 qty of PLU by number)
    2.5*#23-20%       (2.5 qty of PLU by number, 20% discount)
    1.2#4             (charge $1.2 by department 4)
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
* **Profile** - Invoice infos

* **Origin** - Billing source categorization and settings
* **Closure** - Daily and periodical closure reports


**Instalation

    gem 'billing'

    bundle install
    bundle exec bin/rake billing:install
    bundle exec bin/rake db:migrate
    
Enable billing for an ActiveRecord model by adding macro-like class method:

    class MyBillableModel < ActiveRecord::Base
      has_billing
    end

The module will add ***#billing_accounts*** collection to the model.

See [http://alexvangelov.wordpress.com/2014/07/20/ruby-on-rails-app-with-billing-and-fiscalization-part1-billing-model/](http://alexvangelov.wordpress.com/2014/07/20/ruby-on-rails-app-with-billing-and-fiscalization-part1-billing-model/)

There are some rules and restrictions in order to maintain the schema universal:
* Charge may have only one modifier (discount or surcharge).
* Account may have only one global modifier (total discount/surcharge).
* Cascade look-up rule. (Example: If a charge is not initialized with tax group, it looks for tax group in PLU reference. If the PLU doesn't have a tax group, it looks in it's department reference).
* All nomenclature models are STI (Single Table Inheritance) and may be extended by main application.
* Each billing database table has unused integer column ***master_id***, available for global application scopes.

More about ***Origin***

Origin is complex object that is not involved in the billing calculations. It shows where the charges come from and where the account is paid. Each chargable object must respond to origin. The charges in the account may come from multiple origins and each payment belongs to origin. 

When [extface](https://github.com/AlexVangelov/extface) module is included, it's possible to attach print devices to origin and print store information when a charge is created.

Origin also determines the model of payment and fiscal memory device. That's why this object reflects the physical or virtual locations of administrative units for the billing system.

If the application does'n care about the origins, it may have single default origin.


In contrast to desktop applications, where the operator and the access point to program interface are located at the same place, the cloud based billing system has daily and closure reports per origin, not per operator.
