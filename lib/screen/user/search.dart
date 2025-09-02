import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:patient_blockhain/constant/constant.dart';
import 'patientViewData.dart';

class SearchPatientPage extends StatefulWidget {
  const SearchPatientPage({super.key});

  @override
  _SearchPatientPageState createState() => _SearchPatientPageState();
}

class _SearchPatientPageState extends State<SearchPatientPage> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? patient;
  bool isLoading = false;
  bool noResult = false;

  Future<void> searchPatientById() async {
    final regNo = _searchController.text.trim();

    if (regNo.isEmpty) return;

    setState(() {
      isLoading = true;
      patient = null;
      noResult = false;
    });

    try {
      final response = await http.post(
        Uri.parse(myurl),
        body: {'request': 'SEARCH_PATIENT_BY_ID', 'reg_no': regNo},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data is Map && data['reg_no'] != null) {
          setState(() {
            patient = Map<String, dynamic>.from(data);
            noResult = false;
          });
        } else {
          setState(() => noResult = true);
        }
      } else {
        setState(() => noResult = true);
      }
    } catch (e) {
      print("Search error: $e");
      setState(() => noResult = true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Search Patient',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter Patient Reg No...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      patient = null;
                      noResult = false;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: searchPatientById,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Search Patient'),
              ),
            ),
            const SizedBox(height: 30),

            if (isLoading)
              const CircularProgressIndicator()
            else if (noResult)
              const Text(
                'Patient not found 😢',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              )
            else if (patient != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PatientDetailPage(patient: patient!),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "$imgUrl/${patient!['passport_photo']}",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient!['full_name'] ?? 'Unnamed',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Email: ${patient!['email']}"),
                            Text("Phone: ${patient!['phone']}"),
                            Text("Reg No: ${patient!['reg_no']}"),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
