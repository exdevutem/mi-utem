String firstLetterUpperCase(String s) => s.isNotEmpty ? s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : "").toLowerCase() : "";

String capitalize(String s) => s.split(" ").map(firstLetterUpperCase).join(" ");