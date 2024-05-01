import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spk_saw/custom_styles.dart';
import 'package:spk_saw/provider/saw_provider.dart';

class InputAlternatifPage extends StatefulWidget {
  const InputAlternatifPage({super.key});

  @override
  State<InputAlternatifPage> createState() => _InputAlternatifPageState();
}

class _InputAlternatifPageState extends State<InputAlternatifPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SawProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Input Alternatif',
            style: CustomStyles.appBarTextStyle(),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: CircleAvatar(
                          radius:
                              85, // Adjust this value to change the size of the CircleAvatar
                        ),
                      ),
                      Positioned(
                        top:
                            00, // Adjust this value to position the Image.asset
                        child: Image.asset(
                          'assets/images/notes.png',
                          height: 180,
                          width: 180,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Data-data mengenai kandidat yang akan dievaluasi di representasikan',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      contentPadding: const EdgeInsets.all(14.0),
                      labelStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      addAlternatif();
                      provider.saveAlternatives(provider.alternatifList);
                    },
                    child: Text(
                      'Tambah Alternatif',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.alternatifList.length,
                    itemBuilder: (context, index) {
                      final alternatif = provider.alternatifList[index];
                      return ListTile(
                        leading: Text(
                          '${index + 1}.',
                          style: GoogleFonts.inter(fontSize: 18),
                        ), // Add this line
                        title: Text(
                          alternatif.name,
                          style: GoogleFonts.inter(),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.removeAlternatifAt(index);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void addAlternatif() {
    final name = nameController.text;

    if (name.isNotEmpty) {
      final provider = Provider.of<SawProvider>(context, listen: false);
      provider.addAlternatif(
        name,
      );
      setState(() {
        nameController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please fill in all fields correctly.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
