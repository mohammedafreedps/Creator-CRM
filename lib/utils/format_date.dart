String formatDate(String? date) {
  if (date == null) return '';

  try {
    final parsed = DateTime.parse(date);
    return "${parsed.day}/${parsed.month}/${parsed.year}";
  } catch (_) {
    return '';
  }
}