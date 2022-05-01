class CommonUtil {
  static void nextTick(Function function) {
    Future.delayed(Duration.zero, () async {
      function();
    });
  }

  static String capitalizeFirstLetter(String string) {
    return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
  }
}
