#This script conditionally removes, renames, reprices, and reorders Shopify shipping rates.

#global variables
$ShippingRates = {}
$ExemptCountry = false
$OversizedItem = false
$AllowCurbside = false
$HasPreOrder = false
$EstimatedShipDate = ''
$HasRestrictedItems = false
$PreOrderCount = 0
$NotPreOrderCount = 0
$Zip = 00000
$CartZip = Input.cart.shipping_address.zip
$newProps = {}
$newProps['Estimated Ship Date'] = 'Nov 9'

#Country Codes exempt from Universal restrictions
$CountryCodes = Array[
  "US", "CA", "BZ", "BO", "BR", "CL", "CO", "CR", "SV", "GT",
  "HN", "MX", "NI", "PA", "PE",
  "AT", "BE", "DK", "FI", "FR", "DE", "GR", "IS", "IE", "IT",
  "LU", "NL", "NO", "PL", "PT", "ES", "SE", "CH", "GB",
  "AU", "ID", "MY", "PH", "SG", "KR", "TW", "TH"
]

#Product IDs that have country restrictions
$UniversalIDs = Array[
  3926141763667, 
  3926141206611, 
  3926142025811, 
  3926141403219, 
  3926141010003, 
  3926140715091,
  4164018503763
]

#Zip Codes eligable for Curbside Pickup
$CurbsideZips = Array[
  90001, 90002, 90003, 90004, 90005, 90006, 90007, 90008, 90009, 90010, 90011, 90012, 90013, 90014, 90015, 90016, 90017, 90018, 90019, 90020, 90021, 90022, 90023, 90024, 90025, 90026, 90027, 90028, 90029, 90030, 90031, 90032, 90033, 90034, 90035, 90036, 90037, 90038, 90039, 90040, 90041, 90042, 90043, 90044, 90045, 90046, 90047, 90048, 90049, 90050, 90051, 90052, 90053, 90054, 90055, 90056, 90057, 90058, 90059, 90060, 90061, 90062, 90063, 90064, 90065, 90066, 90067, 90068, 90069, 90070, 90071, 90072, 90073, 90074, 90075, 90076, 90077, 90078, 90079, 90080, 90081, 90082, 90083, 90084, 90086, 90087, 90088, 90089, 90090, 90091, 90093, 90094, 90095, 90096, 90099, 90134, 90189, 90201, 90202, 90209, 90210, 90211, 90212, 90213, 90220, 90221, 90222, 90223, 90224, 90230, 90231, 90232, 90233, 90239, 90240, 90241, 90242, 90245, 90247, 90248, 90249, 90250, 90251, 90254, 90255, 90260, 90261, 90262, 90263, 90264, 90265, 90266, 90267, 90270, 90272, 90274, 90275, 90277, 90278, 90280, 90290, 90291, 90292, 90293, 90294, 90295, 90296, 90301, 90302, 90303, 90304, 90305, 90306, 90307, 90308, 90309, 90310, 90311, 90312, 90401, 90402, 90403, 90404, 90405, 90406, 90407, 90408, 90409, 90410, 90411, 90501, 90502, 90503, 90504, 90505, 90506, 90507, 90508, 90509, 90510, 90601, 90602, 90603, 90604, 90605, 90606, 90607, 90608, 90609, 90610, 90620, 90621, 90622, 90623, 90623, 90624, 90630, 90630, 90631, 90631, 90632, 90633, 90637, 90638, 90638, 90639, 90640, 90650, 90651, 90652, 90660, 90661, 90662, 90670, 90671, 90680, 90701, 90702, 90703, 90704, 90706, 90707, 90710, 90711, 90712, 90713, 90714, 90715, 90716, 90717, 90720, 90721, 90723, 90731, 90732, 90733, 90734, 90740, 90742, 90743, 90744, 90745, 90746, 90747, 90748, 90749, 90755, 90801, 90802, 90803, 90804, 90805, 90806, 90807, 90808, 90809, 90810, 90813, 90814, 90815, 90822, 90831, 90832, 90833, 90840, 90842, 90844, 90846, 90847, 90848, 90853, 90895, 90899, 91001, 91003, 91006, 91007, 91008, 91009, 91010, 91011, 91012, 91016, 91017, 91020, 91021, 91023, 91024, 91025, 91030, 91031, 91040, 91041, 91042, 91043, 91046, 91066, 91077, 91101, 91102, 91103, 91104, 91105, 91106, 91107, 91108, 91109, 91110, 91114, 91115, 91116, 91117, 91118, 91121, 91123, 91124, 91125, 91126, 91129, 91182, 91184, 91185, 91188, 91189, 91199, 91201, 91202, 91203, 91204, 91205, 91206, 91207, 91208, 91209, 91210, 91214, 91221, 91222, 91224, 91225, 91226, 91301, 91302, 91303, 91304, 91305, 91306, 91307, 91308, 91309, 91310, 91311, 91313, 91316, 91321, 91322, 91324, 91325, 91326, 91327, 91328, 91329, 91330, 91331, 91333, 91334, 91335, 91337, 91340, 91341, 91342, 91343, 91344, 91345, 91346, 91350, 91351, 91352, 91353, 91354, 91355, 91356, 91357, 91361, 91362, 91364, 91365, 91367, 91371, 91372, 91376, 91380, 91381, 91382, 91383, 91384, 91385, 91386, 91387, 91390, 91392, 91393, 91394, 91395, 91396, 91401, 91402, 91403, 91404, 91405, 91406, 91407, 91408, 91409, 91410, 91411, 91412, 91413, 91416, 91423, 91426, 91436, 91470, 91482, 91495, 91496, 91499, 91501, 91502, 91503, 91504, 91505, 91506, 91507, 91508, 91510, 91521, 91522, 91523, 91526, 91601, 91602, 91603, 91604, 91605, 91606, 91607, 91608, 91609, 91610, 91611, 91612, 91614, 91615, 91616, 91617, 91618, 91701, 91702, 91706, 91708, 91709, 91710, 91711, 91714, 91715, 91716, 91722, 91723, 91724, 91729, 91730, 91731, 91732, 91733, 91734, 91735, 91737, 91739, 91740, 91741, 91743, 91744, 91745, 91746, 91747, 91748, 91749, 91750, 91752, 91754, 91755, 91756, 91758, 91759, 91759, 91761, 91762, 91763, 91764, 91765, 91766, 91766, 91767, 91768, 91769, 91770, 91771, 91772, 91773, 91775, 91776, 91778, 91780, 91784, 91785, 91786, 91788, 91789, 91790, 91791, 91792, 91793, 91801, 91802, 91803, 91804, 91896, 91899, 91901, 91902, 91903, 91905, 91906, 91908, 91909, 91910, 91911, 91912, 91913, 91914, 91915, 91916, 91917, 91921, 91931, 91932, 91933, 91934, 91935, 91941, 91942, 91943, 91944, 91945, 91946, 91948, 91950, 91951, 91962, 91963, 91976, 91977, 91978, 91979, 91980, 91987, 92003, 92004, 92007, 92008, 92009, 92010, 92011, 92013, 92014, 92018, 92019, 92020, 92021, 92022, 92023, 92024, 92025, 92026, 92027, 92028, 92028, 92029, 92030, 92033, 92036, 92037, 92038, 92039, 92040, 92046, 92049, 92051, 92052, 92054, 92055, 92056, 92057, 92058, 92059, 92060, 92061, 92064, 92065, 92066, 92067, 92068, 92069, 92070, 92071, 92072, 92074, 92075, 92078, 92079, 92081, 92082, 92083, 92084, 92085, 92086, 92088, 92091, 92092, 92093, 92096, 92101, 92102, 92103, 92104, 92105, 92106, 92107, 92108, 92109, 92110, 92111, 92112, 92113, 92114, 92115, 92116, 92117, 92118, 92119, 92120, 92121, 92122, 92123, 92124, 92126, 92127, 92128, 92129, 92130, 92131, 92132, 92134, 92135, 92136, 92137, 92138, 92139, 92140, 92142, 92143, 92145, 92147, 92149, 92150, 92152, 92153, 92154, 92155, 92158, 92159, 92160, 92161, 92163, 92165, 92166, 92167, 92168, 92169, 92170, 92171, 92172, 92173, 92174, 92175, 92176, 92177, 92178, 92179, 92182, 92186, 92187, 92191, 92192, 92193, 92195, 92196, 92197, 92198, 92199, 92201, 92202, 92203, 92210, 92211, 92220, 92223, 92225, 92226, 92230, 92234, 92235, 92236, 92239, 92240, 92241, 92242, 92247, 92248, 92252, 92253, 92254, 92255, 92256, 92258, 92260, 92261, 92262, 92263, 92264, 92267, 92268, 92270, 92274, 92276, 92277, 92278, 92280, 92282, 92284, 92285, 92286, 92301, 92304, 92305, 92307, 92308, 92309, 92310, 92311, 92312, 92313, 92314, 92315, 92316, 92317, 92318, 92320, 92321, 92322, 92323, 92324, 92324, 92325, 92327, 92329, 92331, 92332, 92333, 92334, 92335, 92336, 92337, 92338, 92339, 92340, 92341, 92342, 92344, 92345, 92346, 92347, 92350, 92352, 92354, 92356, 92357, 92358, 92359, 92363, 92364, 92365, 92366, 92368, 92369, 92371, 92372, 92373, 92373, 92374, 92375, 92376, 92377, 92378, 92382, 92385, 92386, 92391, 92392, 92393, 92394, 92395, 92397, 92398, 92399, 92399, 92401, 92402, 92403, 92404, 92405, 92406, 92407, 92408, 92410, 92411, 92413, 92415, 92418, 92423, 92427, 92501, 92502, 92503, 92504, 92505, 92506, 92507, 92508, 92509, 92513, 92514, 92516, 92517, 92518, 92519, 92521, 92522, 92530, 92531, 92532, 92536, 92539, 92543, 92544, 92545, 92546, 92548, 92549, 92551, 92552, 92553, 92554, 92555, 92556, 92557, 92561, 92562, 92563, 92564, 92567, 92570, 92571, 92572, 92581, 92582, 92583, 92584, 92585, 92586, 92587, 92589, 92590, 92591, 92592, 92593, 92595, 92596, 92599, 92602, 92603, 92604, 92605, 92606, 92607, 92609, 92610, 92612, 92614, 92615, 92616, 92617, 92618, 92619, 92620, 92623, 92624, 92625, 92626, 92627, 92628, 92629, 92630, 92637, 92646, 92647, 92648, 92649, 92650, 92651, 92652, 92653, 92654, 92655, 92656, 92657, 92658, 92659, 92660, 92661, 92662, 92663, 92672, 92673, 92674, 92675, 92676, 92677, 92678, 92679, 92683, 92684, 92685, 92688, 92690, 92691, 92692, 92693, 92694, 92697, 92698, 92701, 92702, 92703, 92704, 92705, 92706, 92707, 92708, 92711, 92712, 92728, 92735, 92780, 92781, 92782, 92799, 92801, 92802, 92803, 92804, 92805, 92806, 92807, 92808, 92809, 92811, 92812, 92814, 92815, 92816, 92817, 92821, 92822, 92823, 92825, 92831, 92832, 92833, 92834, 92835, 92836, 92837, 92838, 92840, 92841, 92842, 92843, 92844, 92845, 92846, 92850, 92856, 92857, 92859, 92860, 92861, 92862, 92863, 92864, 92865, 92866, 92867, 92868, 92869, 92870, 92871, 92877, 92878, 92879, 92880, 92880, 92881, 92882, 92883, 92885, 92886, 92887, 92899, 93243, 93510, 93516, 93532, 93534, 93535, 93536, 93539, 93543, 93544, 93550, 93551, 93552, 93553, 93555, 93560, 93562, 93563, 93584, 93586, 93590, 93591, 93592, 93599
]

#Method for checking if is integer
def is_integer?
  self.to_i.to_s == self
end

#Method for checking if an array, string or hash does not include
def exclude(value)
  if self.include? value
    false
  else
    true
  end
end

#Format shipping zip code
if $CartZip != nil and $CartZip.length >= 5
  $Zip = Input.cart.shipping_address.zip[0,5]
  if $Zip.is_integer?
    $Zip = Integer($Zip)
  else
    $Zip = 00000
  end
end

#Check for curbside pickup elegibility
if $CurbsideZips.include?($Zip)
  $AllowCurbside = true
end

#Set global variables dependent on line_item info
Input.cart.line_items.each do |line_item|

  #Check for oversized items
  if line_item.variant.product.tags.include?("OversizedItem")
    $OversizedItem = true
  end

  #Check for preorder items
  if line_item.variant.product.tags.include?("preorder") or line_item.variant.product.tags.include?("PREORDER")
    $HasPreOrder = true
    $PreOrderCount += 1
    $EstimatedShipDate = line_item.properties['Estimated Ship Date'] ? line_item.properties['Estimated Ship Date'] : ''
  else
    $NotPreOrderCount += 1
  end

  #Check for items with country restrictions
  if $UniversalIDs.include?(line_item.variant.product.id)
    $HasRestrictedItems = true
  end
end

#Check if country is exempt from Universal restrictions
if $CountryCodes.include?(Input.cart.shipping_address.country_code)
  $ExemptCountry = true
end

#Assign shipping rates if all items eligible
if $ExemptCountry
  $ShippingRates = Input.shipping_rates
else
  unless $HasRestrictedItems
    $ShippingRates = Input.shipping_rates
  end
end

#Continue if we still have shipping rates
if $ShippingRates.length >= 1

  #Add USPS shipping method as suffix to Free Shipping
  $ShippingRates = $ShippingRates.each do |shipping_rate|
    if shipping_rate.name.upcase == 'FREE SHIPPING'
      if Input.cart.total_weight > 453.59237
        new_name = shipping_rate.name + ' - Priority Mail'
        shipping_rate.change_name(new_name)
      else
        new_name = shipping_rate.name + ' - First Class Mail'
        shipping_rate.change_name(new_name)
      end
    end
  end

  #Handle carts with oversized items
  if $OversizedItem
    valid_rates = Array['Oversized Item Fee', 'Curbside Pickup']
    #Delete all rates that are not for Oversized Items
    $ShippingRates = $ShippingRates.sort_by(&:name).delete_if do |shipping_rate|
      valid_rates.exclude(shipping_rate.name) == true
    end
  else
    #Delete oversized item rate
    $ShippingRates = $ShippingRates.sort_by(&:name).delete_if do |shipping_rate|
      shipping_rate.name.include? 'Oversized Item'
    end
  end

  #Handle carts ineligible for curbside pickup
  if $AllowCurbside == false
    $ShippingRates = $ShippingRates.sort_by(&:name).delete_if do |shipping_rate|
      shipping_rate.name.upcase == "CURBSIDE PICKUP"
    end
  end

  #Handle carts without pre-order items
  if $HasPreOrder == false
    $ShippingRates = $ShippingRates.sort_by(&:name).delete_if do |shipping_rate|
      shipping_rate.name.upcase == "SHIP AVAILABLE ITEMS NOW, PREORDER ITEMS SHIP LATER" or shipping_rate.name.upcase == "SHIP COMPLETE ORDER WHEN ALL ITEMS AVAILABLE"
    end
  end

  #Handle carts with pre-order items
  #Rename Oversized Item Shipping
  if $HasPreOrder == true
   $ShippingRates = $ShippingRates.each do |shipping_rate|
      if shipping_rate.name == 'Oversized Item Fee'
        new_name = shipping_rate.name + ' - SHIPS COMPLETE WHEN ALLL ITEMS AVAILABLE'
        shipping_rate.change_name(new_name)
      end
    end
  end

  #Removes standard shipping methods if order has Pre-order item
  if $HasPreOrder == true
    $ShippingRates = $ShippingRates.sort_by(&:name).delete_if do |shipping_rate|
      shipping_rate.name.upcase.include? "FEDEX" or shipping_rate.name.upcase.include? "USPS" or shipping_rate.name.upcase.include? "FREE"
    end
    if $EstimatedShipDate.length > 0
      $ShippingRates.each do |shipping_rate|
        rate_name = shipping_rate.name + ' (' + $EstimatedShipDate +')'
        shipping_rate.change_name(rate_name)
      end
    end
  end

  #Removes SHIP AVAILABLE ITEMS NOW, PREORDER ITEMS SHIP LATER from orders with single line item
  if $HasPreOrder == true
    if $NotPreOrderCount < 1
      $ShippingRates = $ShippingRates.sort_by(&:name).delete_if do |shipping_rate|
        shipping_rate.name.upcase.include? "SHIP AVAILABLE ITEMS NOW, PREORDER ITEMS SHIP LATER"
      end
    end
  end

  #Sorts rates by price Asc, Desc if order has Pre-order item
  $ShippingRates = $HasPreOrder ? $ShippingRates.sort_by(&:price).reverse! : $ShippingRates.sort_by(&:price)

  #Moves Curbside Pickup to the bottom of the list
  if $ShippingRates.length > 1
    if $ShippingRates.first.name.upcase == "CURBSIDE PICKUP"
        $ShippingRates.rotate!
    end
  end
end

Output.shipping_rates = $ShippingRates