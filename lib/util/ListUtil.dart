class ListUtil {
  static bool compareList(List list1, List list2) {
    List list = [...list1]; //深拷贝
    list.addAll(list2);
    Set temp = Set(); //用set进行去重
    temp.addAll(list);
    return list1.length == (list1.length + list2.length + temp.length) / 3;
  }
}
