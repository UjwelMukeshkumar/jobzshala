// String formatCurrency(int value, {String symbol = 'AED', String suffix = ''}) {
//   final formattedNumber = _formatIntegerWithCommas(value.abs());
//   final sign = value < 0 ? '-' : '';
//   return '$sign$symbol $formattedNumber$suffix';
// }

// String formatCurrencyRange(
//   int minValue,
//   int maxValue, {
//   String symbol = 'AED',
//   String suffix = '',
// }) {
//   return '${formatCurrency(minValue, symbol: symbol, suffix: suffix)} - ${formatCurrency(maxValue, symbol: symbol, suffix: suffix)}';
// }

// String formatPercentage(double value) {
//   return '${value.toStringAsFixed(1)}%';
// }

// String formatRelativeDate(DateTime dateTime) {
//   final now = DateTime.now();
//   final difference = now.difference(dateTime);

//   if (difference.inDays < 0) {
//     return 'Upcoming';
//   }

//   if (difference.inDays == 0) {
//     return 'Today';
//   }

//   if (difference.inDays == 1) {
//     return '1 day ago';
//   }

//   if (difference.inDays < 30) {
//     return '${difference.inDays} days ago';
//   }

//   final months = (difference.inDays / 30).floor();
//   if (months == 1) {
//     return '1 month ago';
//   }

//   if (months < 12) {
//     return '$months months ago';
//   }

//   final years = (difference.inDays / 365).floor();
//   if (years == 1) {
//     return '1 year ago';
//   }

//   return '$years years ago';
// }

// String capitalize(String value) {
//   if (value.trim().isEmpty) {
//     return value;
//   }

//   return value[0].toUpperCase() + value.substring(1);
// }

// bool isBlank(String? value) {
//   return value == null || value.trim().isEmpty;
// }

// String _formatIntegerWithCommas(int value) {
//   final stringValue = value.toString();
//   final buffer = StringBuffer();

//   for (var i = 0; i < stringValue.length; i++) {
//     final indexFromEnd = stringValue.length - i;
//     final char = stringValue[i];

//     if (i > 0 && indexFromEnd > 0 && (indexFromEnd % 3 == 0)) {
//       buffer.write(',');
//     }

//     buffer.write(char);
//   }

//   return buffer.toString();
// }
