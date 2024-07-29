String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input; // Return the input as is if it's null or empty
  }
  return input[0].toUpperCase() + input.substring(1);
}
