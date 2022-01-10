class DataProvider {
  static List<Map> _elements = [
    {
      'name': '1.jpg',
      'time': DateTime.utc(2021, 10, 12),
      'tag': ['House', 'Mountain']
    },
    {
      'name': '2.jpg',
      'time': DateTime.utc(2021, 10, 10),
      'tag': ['Island']
    },
    {
      'name': '3.jpg',
      'time': DateTime.utc(2021, 10, 10),
      'tag': ['Raccoon']
    },
    {
      'name': '4.jpg',
      'time': DateTime.utc(2021, 10, 10),
      'tag': ['tree', 'stone']
    },
    {
      'name': '5.jpg',
      'time': DateTime.utc(2021, 10, 9),
      'tag': ['humberger']
    },
    {
      'name': '6.jpg',
      'time': DateTime.utc(2021, 10, 9),
      'tag': ['fruit']
    },
  ];

  static List<Map> getElements() {
    return _elements;
  }
}
