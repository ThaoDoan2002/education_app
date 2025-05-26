class CourseParams {
  final int page;
  final int cateID;

  CourseParams({required this.page, required this.cateID});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CourseParams &&
              runtimeType == other.runtimeType &&
              page == other.page &&
              cateID == other.cateID;

  @override
  int get hashCode => Object.hash(page, cateID);
}
