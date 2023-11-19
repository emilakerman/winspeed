// ignore_for_file: file_names

enum WindowSizeEnum {
  desktop(600, 700, "Desktop");

  const WindowSizeEnum(this.width, this.height, this.description);
  final double width;
  final double height;
  final String description;
}
