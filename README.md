billing
=======

Billing module for rails 4 app

*This module is currently in development stage*

## The idea

Bill text constructor protocol:
  
    1.2               (charge $1.2)   / default currency or $
    +1.2              (charge $1.2)
    2*4,5             (2 charges $4.5)
    10-50%            (charge $10 with 50% discount)
    10-2              (charge $20, discount $2)
    #23               (charge by PLU number)
    2*#23             (2 charges by PLU number)
    2*#23-20%         (2 charges by PLU number, 20% discount each)
    -10%              (discount 10% whole bill)
    -5                (discount $5)
    @2/10             (payment $10 with payment type 2)
    @1                (auto calculated payment with payment type 1 / or default payment type if not specified)            

* Universal fiscal device compatible basket