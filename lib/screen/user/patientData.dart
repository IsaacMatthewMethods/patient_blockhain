import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:patient_blockhain/constant/constant.dart';

import 'patientViewData.dart';

class PatientDataPage extends StatefulWidget {
  @override
  _PatientDataPageState createState() => _PatientDataPageState();
}

class _PatientDataPageState extends State<PatientDataPage> {
  List<dynamic> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final response = await http.post(
        Uri.parse(myurl),
        body: {'request': 'VIEW_PATIENTS'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          patients = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Patient Records',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : patients.isEmpty
          ? const Center(child: Text('No patient data available'))
          : ListView.builder(
              itemCount: patients.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(
                        "${imgUrl}/${patient['passport_photo']}",
                      ),
                    ),
                    title: Text(
                      patient['full_name'] ?? 'Unnamed',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ${patient['email']}"),
                          Text("Phone: ${patient['phone']}"),
                          Text("Reg No: ${patient['reg_no']}"),
                          const SizedBox(height: 6),
                          Chip(
                            label: Text(patient['gender'] ?? 'Unknown'),
                            backgroundColor: patient['gender'] == 'Female'
                                ? Colors.pink.shade50
                                : Colors.blue.shade50,
                            labelStyle: TextStyle(
                              color: patient['gender'] == 'Female'
                                  ? Colors.pink
                                  : Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PatientDetailPage(patient: patients[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
