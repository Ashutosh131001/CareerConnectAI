import 'package:careerconnect/company/companyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// The Interface (Abstraction)
abstract class CompanyRepository {
  Future<void> saveCompany(CompanyModel company);
  Future<List<CompanyModel>> getAllCompanies();
}

// The Concrete Implementation
class FirebaseCompanyRepository implements CompanyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveCompany(CompanyModel company) async {
    try {
      // If the ID is empty, it's a new company, so we let Firestore generate the ID
      if (company.id.isEmpty) {
        await _firestore.collection('companies').add(company.toMap());
      } else {
        // Otherwise, update the existing one
        await _firestore.collection('companies').doc(company.id).set(company.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception('Failed to save company: $e');
    }
  }

  @override
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      final snapshot = await _firestore.collection('companies').get();
      return snapshot.docs
          .map((doc) => CompanyModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch companies: $e');
    }
  }
}