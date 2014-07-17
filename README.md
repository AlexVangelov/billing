billing
=======

Billing module for rails 4 app

## The idea

    billing_account.new(origin: web, currecy: 'USD') do |bill|
      bill.charge price: 1.2, descrption: :something
      bill.charge price: 2, descrption: :something else
      bill.discount '10%'
      bill.pay payment_type2, value: 1.0
      bill.pay payment_type1
    end
    # [Extface](https://github.com/AlexVangelov/extface) compatible basket
