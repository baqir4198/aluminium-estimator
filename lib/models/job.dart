import 'dart:ui';

enum JobStatus {
  quoted('Quoted', Color(0xFFE3E8EE), Color(0xFF2F3A46)),
  inFabrication('In fabrication', Color(0xFFFDE7D6), Color(0xFF9A3412)),
  installed('Installed', Color(0xFFDDF0E2), Color(0xFF1E5E34));

  const JobStatus(this.label, this.background, this.foreground);
  final String label;
  final Color background;
  final Color foreground;
}

class Job {
  const Job({
    required this.customer,
    required this.summary,
    required this.amount,
    required this.status,
  });

  final String customer;
  final String summary;
  final int amount;
  final JobStatus status;
}
