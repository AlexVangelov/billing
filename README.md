billing
=======

Billing module for rails 4 app

*This module is currently in development stage*

## The idea

Bill text constructor protocol:
  
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

* Universal fiscal device compatible basket

###Charge

    [qty*][price][#PLU][@tax]][+surcharge[%]/-discount[%]][/text]
    
###Discount/Surcharge

    [+/-[value[%]]][/text]
    
###Payment

    @[type[/value]][#profile]
