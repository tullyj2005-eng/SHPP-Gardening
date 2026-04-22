import 'package:flutter/material.dart';

// --- DATA MODEL ---
// This tells the app what information a 'TrackedPlant' must have
class TrackedPlants {
  final String name;
  final double waterProgress;

  TrackedPlants({
    required this.name,
    required this.waterProgress,
  });
}


// --- PLANT WIDGETS ---

// --plant widgets are in greek-- 


// mint
Widget mint(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Μέντα";
  
  const List<String> descriptionText = [
      "Η άγρια μέντα (Mentha aquatica), όπως σχεδόν όλα τα είδη μέντας, είναι πολυετές φυτό. Ξεχωρίζει για το έντονο άρωμά της και τα ροζ-μωβ άνθη που παράγει την άνοιξη και το καλοκαίρι. Αγαπά τα πλούσια, υγρά εδάφη και τις ηλιόλουστες τοποθεσίες, ενώ χρειάζεται προστασία από τον παγετό. Το έντονο άρωμα των φύλλων της την καθιστά ιδανική για αφέψημα και παραγωγή αιθέριου ελαίου. Ταξινομείται ως παραδοσιακό φαρμακευτικό προϊόν φυτικής προέλευσης,εξαιτίας της δράσης της κατά των στομαχικών διαταραχών και πόνων. "
      ]; // Joins the list into a single string with double line breaks


  const String howToText = 
  "Τα φυτά της οικογένειας της μέντας προτιμούν πλούσια, υγρά εδάφη με θέσεις με ήλιο ή ημισκιά. Χρειάζονται περισσότερο πότισμα κατά τις περιόδους ξηρασίας και καύσωμα, ενώ έχουν μέτριες απαιτήσεις σε νερό καθ’ όλη τη διάρκεια του έτους. Η μέντα σοκολάτα έχει καλή αντοχή στο κρύο, ενώ ο δυόσμος είναι πιο ανθεκτικό σε υψηλές θερμοκρασίες. Συνίσταται η ενίσχυση του εδάφους με αζωτούχο λίπανση τον Φεβρουάριο και μετά την πρώτη συγκομιδή.  ";
  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        ' Μέντα', 
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
            child: Image.asset('assets/Mint.png', width: 150, height: 150, fit: BoxFit.contain),
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


// ROSEMARY
Widget rosemary(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Δενδολίβανο";
  
  const List<String> descriptionText = [
      " Το έρπον δενδρολίβανο (Rosmarinus officinalis prostratus) είναι ένα αειθαλές, πολυετές φυτό, το οποίο εξελίσσεται σε έναν μεγάλο , πυκνό θάμνο που απλώνει τα κλαδιά του πλευρικά. Είναι ένα από τα πιο ανθεκτικά αρωματικά φυτά, τόσο σε γλάστρα όσο και στο έδαφος. Την άνοιξη και το φθινόπωρο παράγει μικρά λαο λευκά άνθη. Προτιμά ηλιόλουστα, ξηρά περιβάλλοντα και, αν φυτευτεί στο έδαφος μπορεί να ποτίζεται αποκλειστικά από την βροχή. Καθ’ όλη την διάρκεια του έτους μπoρείτε να συλλέξετε τα φύλλα για την μαγειρική. Τα άνθη του πρoσeλκύουν τις μέλισσες και γi' αυτό χρησιμoπoιoύ νtαι ευρέως σtη ν μeλiσσoκoμίa.Έχeι πeρiγpafeί ωs πaρaδoσiakό φaρμaκeυtikό πpωϊόn γi' tη ν αントiμeтώπiση tης δyσpeψίaς, δyσmηnόppoiaς και tου πoноkefału."
      ]; // Joins the list into a single string with double line breaks


  const String howToText = 
        "Προτιμά ηλιόλουστο, ξηρό και ζεστό περιβάλλον. Είναι ανθεκτικό στον παγετό και τις χαμηλές θερμοκρασίες. Έχει χαμηλές έως ελάχιστες απαιτήσεις σε πότισμα. Τα ωριμα φυτά μπορούν να βασιστούν μόνο στη βροχόπτωση, εφόσον η ετήσια βροχή υπερβαίνει τα 400 χιλιοστά.";
  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Δεντρολίβανο', 
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
            child: Image.asset('assets/ROSEMARY.jpg', width: 150, height: 150, fit: BoxFit.contain),
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



// --DITTANY--
Widget dittany(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Δίκταμο";
  
  const List<String> descriptionText = [
    "Το δίκταμο (Origanum dictamnus), γνωστό και ως «δίκταμο της Κρήτης» , είναι ένας μικρός αρωματικός θάμνος με στρογγυλά φύλλα και όμορφα και όμορφα ροζ/μωβ άνθη το καλοκαίρι. Αγαπά τις ηλιόλουστες τοποθεσίες και χρειάζεται λίγο πότισμα. Αντέχει τις χαμηλές θερμοκρασίες του χειμώνα, γεγονός που το καθιστά ιδανικό, τόσο για την καλλιέργεια στον αγρό, όσο και για χρήση στο μπαλκόνι. Μπορεί να χρησιμοποιηθεί στο φαγητό, σε σαλάτες και ψητά αντί για ρίγανη (και τα άνθη και τα φυτά). Συνιστά, επίσης, ως αφέψημα για τις καταπραϋντικές του ιδιότητες. "
  ]; 

  const String howToText = 
  "Χρειάζεται άφθονο ηλιακό φως και σχετικά υψηλές θερμοκρασίες. Χρειάζεται πότισμα κάθε 10 με 15 ημέρες εάν δεν βρέχει τον χειμώνα και πιο τακτικά το καλοκαίρι. Απαιτεί υψόμετρο μεγαλύτερο των 300 μέτρων. Είναι ανθεκτικό σε χαμηλές θερμοκρασίες. Τα κύρια προβλήματα μπορεί να προκύψουν από το υπερβολικό πότισμα αν και υπάρχει κίνδυνος προσβολής από βοτρύτη. ";
  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        ' Δίκταμο', 
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
            child: Image.asset('assets/Leaf (1).png', width: 150, height: 150, fit: BoxFit.contain),
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

// --THYME--
Widget thyme(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Θυμάρι";
  
  const List<String> descriptionText = [
    "Το θυμάρι  (Thymus Vulgaris) είναι ένα πολυετές φυτό με χαμηλές απαιτήσεις σε νερό και υψηλές απαιτήσεις σε ηλιακό φως. Ευδοκιμεί σε φτωχά εδάφη, με αποτέλεσμα να προτιμάται στην καλλιέργεια. Η υψηλή του ανθεκτικότητα το καθιστά ιδανικό φυτό γλάστρας για αρχάριους, ενώ ενδεικνυται γενικότερα για φύτευση σε φυτοδοχεία. Χρησιμοποιείται ευρέως στη μαγειρική, ιδιαίτερα στα ψητά και στις μαρινάδες. Αποτελεί, επίσης, σημαντικό μελισσοκομικό φυτό, καθώς χρησιμοποιείται για την παραγωγή αρωματικού μελιού. Το αιθέριο έλαιό του είναι κοιν΄συστατικό στην αρωματοποιία και την κοσμετολογία. Τα φύλλα του έχουν ταξινομηθεί ως παραδοσιακό φυτικό φαρμακευτικό προϊόν για την αντιμετώπιση του βήχα."
  ]; 

  const String howToText = 
  "Απαιτεί πλήρη έκθεση στον ήλιο και καλή αποστράγγιση.  Είναι ανθεκτικό στην ξηρασία, με χαμηλές ανάγκες σε νερό. Ευδοκιμεί ικανοποιητικά σε φτωχά εδάφη. ";
  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Θυμάρι ', 
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
            child: Image.asset('assets/Thyme.png', width: 150, height: 150, fit: BoxFit.contain),
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


// --OREGANO--
Widget oregano(BuildContext context, VoidCallback onTrack) {
  const String plantName = "Ρίγανη";
  
  const List<String> descriptionText = [
    "Η νησιωτική ρίγανη (Origanum onites) είναι ένα ιδιαίτερο είδος ρίγανης με δυνατό και γλυκό άρωμα. Είναι ένα ξηροφυτικό είδος, που δεν χρειάζεται πολύ νερό και ευδοκιμεί με τον ήλιο. Καταλληλη για φύτευση σε γλάστρα στο μπαλκόνι, καθώς είναι το ιδανικό αρωματικό φυτό για αρχάριους στην καλλιέργεια! Τα άνθη και τα φύλλα προσθέτουν γεύση σε όλα τα φαγητά, αλλά μπορεί και σε μικρές ποσότητες να χρησιμοποιηθεί σε ροφήματα."
  ]; 

  const String howToText = 
  "Ξηροφυτικό είδος χωρίς ιδιαίτερες ανάγκες σε νερό. Απαιτεί μερική ή πλήρη έκθεση στο φως του ήλιου. Δεν υπάρχουν ιδιαίτερες απαιτήσεις ως προς το έδαφος, αρκεί να υπάρχει καλή αποστράγγιση για την απομάκρυνση του νερού. Είναι ανθεκτικό σε φτωχά και πετρώδη περιβάλλοντα.";
  return InkWell(
    onTap: () {
      showPlantDetails(
        context, 
        'Ρίγανη', 
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
            child: Image.asset('assets/Leaf (1).png', width: 150, height: 150, fit: BoxFit.contain),
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
                const Text('Περιγραφή', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(color: Colors.green),
                Text(description),
                
                const SizedBox(height: 20),

                const Text('Φροντίδα', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
            child: const Text('Επιλογή φυτού'),
          ),

          // --- CLOSE BUTTON ---
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Κλείσιμο', style: TextStyle(color: Colors.grey)),
          ),
        ],
      );
    },
  );
}