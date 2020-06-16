# Add Line Item Specific Discounts
This is useful when discount amounts vary conditionally.
---

## fathers_day_2020 
In this script, products of type "Collectibles" receive a 20% discount where as products of type "### Apparel" receive a 10% discount.
---
### Sudo
1. iterate over ```cart.line_items```
2. check if ```line_item.variant.product.product_type``` meets conditions
  1. assign discount amount based on ```product_type```
  2. iterate of ```product.tags``` to check for eligibility
  3. if eligible, change ```line_item.line_price```