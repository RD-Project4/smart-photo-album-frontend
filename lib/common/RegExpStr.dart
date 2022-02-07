class RegExpStr {
  static const EMAIL = r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$';
  static const URL =
      r'[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?';
  static const INTERNET_URL = r'[a-zA-z]+://[^\s]*';
  static const PHONE_NUM = r'^(13[0-9]|14[5|7]|15[0|1|2|3|4|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$';

}
