// Capitalize the first letter of a string, and if it has more than one word, capitalize the first letter of each word.
// Also does nothing if the string is null or empty.
String capitalize(String s) => s.split(" ").map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : "").join(" ");