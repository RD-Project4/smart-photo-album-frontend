class CommonUtil {
  static void nextTick(Function function) {
    Future.delayed(Duration.zero, () async {
      function();
    });
  }
}
