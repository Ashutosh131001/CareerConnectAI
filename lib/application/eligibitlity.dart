import 'package:careerconnect/placementDrive/placementdriveModel.dart';

// 1. The Result Object (Required by the rubric to return reasons)
class EligibilityResult {
  final bool isEligible;
  final List<String> reasons;

  EligibilityResult({required this.isEligible, required this.reasons});
}

// 2. The Strategy Interface (The core of the pattern)
abstract class EligibilityPolicy {
  EligibilityResult evaluate(Map<String, dynamic> studentData, PlacementDriveModel drive);
}

// 3. A Concrete Implementation of the Strategy
class StandardDriveEligibility implements EligibilityPolicy {
  @override
  EligibilityResult evaluate(Map<String, dynamic> studentData, PlacementDriveModel drive) {
    List<String> reasons = [];
    
    // Safely parse stats
    final double studentCgpa = (studentData['cgpa'] ?? 0.0).toDouble();
    final int studentBacklogs = studentData['activeBacklogs'] ?? 0;

    // Check CGPA
    if (studentCgpa < drive.minCgpa) {
      reasons.add('Minimum CGPA required: ${drive.minCgpa}; current CGPA: $studentCgpa');
    }

    // Check Backlogs
    if (studentBacklogs > drive.maxActiveBacklogs) {
      reasons.add('Maximum backlogs allowed: ${drive.maxActiveBacklogs}; you have $studentBacklogs');
    }

    // Return the final packaged result
    return EligibilityResult(
      isEligible: reasons.isEmpty,
      reasons: reasons,
    );
  }
}