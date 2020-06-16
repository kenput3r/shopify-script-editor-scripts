Input.cart.line_items.each do |line_item|
  product = line_item.variant.product
  eligible = true
  if product.product_type == "Kid's Apparel" or product.product_type == "Men's Apparel" or product.product_type == "Women's Apparel" or product.product_type == "Collectibles"
    discount = product.product_type == "Collectibles" ? 0.80 : 0.90
    product.tags.each do |tag|
      if tag == "Suavecito X Universal Monsters" or tag == "Felix the Cat"
        eligible = false
      end
    end
    if eligible
      message = (100 - discount * 100).to_s + "% Off - Father's Day Sale"
      line_item.change_line_price(line_item.line_price * discount, message: message)
    end
  end
end
Output.cart = Input.cart