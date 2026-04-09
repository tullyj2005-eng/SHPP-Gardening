import 'package:flutter/material.dart';


// --- PLANT WIDGETS ---


// mint
Widget mint(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Mint";
  
  const List<String> descriptionText = [
      "Mojito mint (Mentha rotundifolia), like almost all mint species, is a perennial plant. It is one of the most widely distributed mint species, both for cultivation and ornamental use. It loves rich, moist soils and sunny locations, and needs protection from frosts. Because of its sweet,  fruity taste, it is the most popular choice of mint for cooking, making herbal teas and the well-known drink from which it takes its name. Its leaves can also be used to make refreshing drinks in the summer.\n\n",
      "Wild mint (Mentha aquatica), like almost all mint species, is a perennial plant. It stands out for its intense fragrance and the pinkish-purple flowers it produces in spring and summer. It loves rich, moist soils and sunny locations and needs protection from frosts. The intense fragrance of its leaves makes it ideal for infusions and essential oil. It is classified as a traditional medicinal product of herbal origin because of its action against stomach disorders and pains\n\n",
      "Chocolate mint (Mentha x piperita f.citrata 'Chocolate'), like almost all mint species, is a perennial plant. It loves rich, moist soils and sunny locations and is one of the most cold-tolerant mint species. It stands out mainly because of its taste and aroma, but also because of its distinctive dark leaves. The flavour is deep, with hints of hazelnut and a chocolatey aroma, as the name suggests. It is therefore used mainly in cooking, in desserts and fruit dishes. It is also used in the preparation of beverages. \n\n",
      "Spearmint (Mentha Spicata) is a perennial herb which belongs to the mint family. It loves rich, moist soils and sunny locations and is one of the most heat-tolerant mint species, although it does need regular watering. It is a popular plant for patios and balconies, but is also successfully grown in the field. Because of its strong, characteristic aroma it is widely used in cooking.Its leaves can be used to make refreshing drinks in summer, and its smell seems to drive away mice. The extract and essential oils of spearmint have been shown to have antioxidant, anti-cancer, anti-parasitic, anti-microbial and anti-diabetic properties. \n\n",
      "Pennyroyal  (Mentha pulegium) is a perennial herb belonging to the mint family. It stands out, however, because it is creeping, which makes it ideal for ground coverage.  It loves rich, moist soils and sunny locations and needs protection from frosts. It's ideal for growing in the field, and its pinkish-white flowers make it a striking choice for potting at the balcony. The pennyroyal has been harvested in its wild form since ancient times and is used as a herbal tea. The herbal tea of pennyroyal is traditionally used to treat migraines, gastroesophageal problems, and rheumatism."
      ]; // Joins the list into a single string with double line breaks


  const String howToText = 
      "The mint family prefers rich, moist soil, and positions in sun or semi-shade. It needs more watering during periods of drought and heat, with moderate water requirements throughout the year. Chocolate mint has good cold hardiness, while spearmint is more tolerant of warm temperatures. It is recommended that the soil be amended with nitrogen fertilization in February and after the first harvest for drainage.";

  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Mojito Mint', 
        descriptionText.join('\n\n'), 
        howToText, 
        onTrack // Pass it here
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('Mint.png', width: 150, height: 150, fit: BoxFit.contain),
          ),
          const Text(
            plantName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}


//ROSEMARY
// mint
Widget rosemary(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Rosemary";
  
  const List<String> descriptionText = [
      "Rosmary prostratus (Rosmarinus officinalis prostratus) is an evergreen, perennial plant that develops into a large, dense shrub that spreads its branches sideways. It is one of the most resilient aromatic plants, both while planted in the pot and in the field. In spring and in autumn it produces small blue and white flowers; it prefers sunny, dry environments, and if planted in the ground can be watered exclusively for rainfall.  Throughout the year you can harvest its leaves which are used in cooking. Its flowers attract bees and for this reason it is widely used in beekeeping. It has been described as a traditional medicinal product to treat indigestion, dysmenorrhea and headache\n\n",
      "Rosmary (Rosmarinus officinalis) is an evergreen, perennial plant with tall, straight branches. It is one of the most resilient aromatic plants, both while planted pot and in the field. In spring and in autumn it produces small pink and white flowers; it prefers sunny dry environments, and if planted in the ground can be watered exclusively for rainfall.  Throughout the year you can harvest its leaves which are used in cooking. Its flowers attract bees and for this reason it is widely used in beekeeping. It has been described as a traditional medicinal product to treat indigestion, dyspepsia, dysmenorrhea and headaches.\n\n"
      ]; // Joins the list into a single string with double line breaks


  const String howToText = 
      "Evergreen, perennial plant which is propagated by cuttings (ideal graft size 7-15 cm).  It may have straight branches (Rosmarinus officinalis) or side branches (Rosmarinus officinalis prostratus). The establishment of the crop in the field is done in autumn or spring, after the risk of frosts. It flowers in spring and autumn and is ideally harvested at the beginning of flowering. Prefers a sunny, dry and warm environment; it is resistant to frost and low temperatures. Low to minimal watering requirements. Mature plants can rely on rainfall alone, provided that annual rainfall exceeds 450 mm.";

  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Rosemary', 
        descriptionText.join('\n\n'), 
        howToText, 
        onTrack // Pass it here
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('ROSEMARY.jpg', width: 150, height: 150, fit: BoxFit.contain),
          ),
          const Text(
            plantName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}





//popup function for the plant information
void showPlantDetails(
  BuildContext context, 
  String name, 
  String description, 
  String howTo, 
  VoidCallback onTrack // Add this parameter
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(color: Colors.green),
                Text(description),
                
                const SizedBox(height: 20),

                const Text('How To Grow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(color: Colors.green),
                Text(howTo),
              ],
            ),
          ),
        ),
        actions: [
          // --- NEW TRACK BUTTON ---
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              onTrack(); // This triggers the logic to add it to your main screen
              Navigator.of(context).pop(); // Closes the pop-up
              
              // Optional: Show a little confirmation message at the bottom
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name added to tracked plants!')),
              );
            },
            child: const Text('Track Plant'),
          ),

          // --- CLOSE BUTTON ---
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      );
    },
  );
}