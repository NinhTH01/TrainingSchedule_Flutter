extension TextCapitalize on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this; // Return the input as is if it's null or empty
    }
    return this[0].toUpperCase() + substring(1);
  }
}
