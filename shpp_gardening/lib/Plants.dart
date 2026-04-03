import 'package:flutter/material.dart';


// --- PLANT WIDGETS ---


//mojito mint
Widget mojitoMintPlant(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Mojito Mint";
  
  const String descriptionText = 
      "Mojito mint (Mentha rotundifolia), like almost all mint species, is a perennial plant. It is one of the most widely distributed mint species, both for cultivation and ornamental use. It loves rich, moist soils and sunny locations, and needs protection from frosts. Because of its sweet,  fruity taste, it is the most popular choice of mint for cooking, making herbal teas and the well-known drink from which it takes its name. Its leaves can also be used to make refreshing drinks in the summer.";

  const String howToText = 
      "The mint family prefers rich, moist soil, and positions in sun or semi-shade. It needs more watering during periods of drought and heat, with moderate water requirements throughout the year. Chocolate mint has good cold hardiness, while spearmint is more tolerant of warm temperatures. It is recommended that the soil be amended with nitrogen fertilization in February and after the first harvest for drainage.";

  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Mojito Mint', 
        descriptionText, 
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
            child: Image.asset('assets/Leaf (1).png', width: 100, height: 100),
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

Widget chocolateMintPlant(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Chocolate Mint";
  
  const String descriptionText = 
      "Chocolate mint (Mentha × piperita), like almost all mint species, is a perennial plant. It is one of the most widely distributed mint species, both for cultivation and ornamental use. It loves rich, moist soils and sunny locations, and needs protection from frosts. Because of its sweet,  fruity taste, it is the most popular choice of mint for cooking, making herbal teas and the well-known drink from which it takes its name. Its leaves can also be used to make refreshing drinks in the summer.";

  const String howToText = 
      "The mint family prefers rich, moist soil, and positions in sun or semi-shade. It needs more watering during periods of drought and heat, with moderate water requirements throughout the year. Chocolate mint has good cold hardiness, while spearmint is more tolerant of warm temperatures. It is recommended that the soil be amended with nitrogen fertilization in February and after the first harvest for drainage.";

  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Chocolate Mint', 
        descriptionText, 
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
            child: Image.asset('assets/Leaf (1).png', width: 100, height: 100),
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

//Spearmint
Widget spearmintPlant(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Spearmint";
  
  const String descriptionText = 
      "Spearmint (Mentha Spicata) is a perennial herb which belongs to the mint family. It loves rich, moist soils and sunny locations and is one of the most heat-tolerant mint species, although it does need regular watering. It is a popular plant for patios and balconies, but is also successfully grown in the field. Because of its strong, characteristic aroma it is widely used in cooking.Its leaves can be used to make refreshing drinks in summer, and its smell seems to drive away mice. The extract and essential oils of spearmint have been shown to have antioxidant, anti-cancer, anti-parasitic, anti-microbial and anti-diabetic properties. ";
  const String howToText = 
      "The mint family prefers rich, moist soil, and positions in sun or semi-shade. It needs more watering during periods of drought and heat, with moderate water requirements throughout the year. Chocolate mint has good cold hardiness, while spearmint is more tolerant of warm temperatures. It is recommended that the soil be amended with nitrogen fertilization in February and after the first harvest for drainage.";

  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Spearmint', 
        descriptionText, 
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
            child: Image.asset('assets/Leaf (1).png', width: 100, height: 100),
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

//PennyRoyal
Widget pennyRoyalPlant(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Pennyroyal";
  
  const String descriptionText = 
      "Pennyroyal  (Mentha pulegium) is a perennial herb belonging to the mint family. It stands out, however, because it is creeping, which makes it ideal for ground coverage.  It loves rich, moist soils and sunny locations and needs protection from frosts. It's ideal for growing in the field, and its pinkish-white flowers make it a striking choice for potting at the balcony. The pennyroyal has been harvested in its wild form since ancient times and is used as a herbal tea. The herbal tea of pennyroyal is traditionally used to treat migraines, gastroesophageal problems, and rheumatism.";
    const String howToText = 
      "The mint family prefers rich, moist soil, and positions in sun or semi-shade. It needs more watering during periods of drought and heat, with moderate water requirements throughout the year. Chocolate mint has good cold hardiness, while spearmint is more tolerant of warm temperatures. It is recommended that the soil be amended with nitrogen fertilization in February and after the first harvest for drainage.";

  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Pennyroyal', 
        descriptionText, 
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
            child: Image.asset('assets/Leaf (1).png', width: 100, height: 100),
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