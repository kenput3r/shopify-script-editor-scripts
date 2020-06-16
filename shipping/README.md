# Custom Shipping Rates
This is useful for adding, removing, renaming, sorting and/or discounting shipping rates.

## custom_rates_with_curbside_pickup
In this script, some rates are removed entirely when certain conditions are met.

### Sudo
1. iterate of line items
  * check if cart contains oversized items
  * check if cart contains country based shipping restrictions
2. if cart contains country restrictions
  * if the country is restricted
    1. remove all shipping methods
  * if the country is not restricted
    * if cart has oversized items
      1. remove all non oversized item shipping rates
    * if cart does not have oversized items
      * if cart weight is over 453
        1. remove "oversized item fee" shipping rate
        2. remove "free shipping - first class mail
      * if cart weight is under 453
        1. remove "oversized item fee" shipping rate
        2. remove "free shipping - priority mail" shipping rate
3. if cart does not contain country restrictions
  * if cart contains oversized items
    1. remove all non oversized item shipping rates
  * if cart does not contain oversized items
    * if cart weight is over 453
      1. remove "oversized item fee" shipping rate
      2. remove "free shipping - first class mail
    * if cart weight is under 453
      1. remove "oversized item fee" shipping rate
      2. remove "free shipping - priority mail" shipping rate
4. cast cart zip as Integer
5. check curbside pickup eligiblity
  * if curbside ineligible
    1. remove "curbside pickup" shipping rate
6. sort shipping rates by price
7. move "curbside pickup" shipping rate to the end of the list
