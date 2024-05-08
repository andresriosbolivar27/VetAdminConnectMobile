class PaginationDto {
  int? _id;
  int _page = 1;
  int _recordsNumber = 10;
  String? _filter;

  PaginationDto(
  this._id,
  this._page,
  this._recordsNumber,
  this._filter,
  );

  String? get filter => _filter;
  int get recordsNumber => _recordsNumber;
  int get page => _page;
  int? get id => _id;

  set filter(String? value) {
    _filter = value;
  }

  set recordsNumber(int value) {
    _recordsNumber = value;
  }

  set page(int value) {
    _page = value;
  }

  set id(int? value) {
    _id = value;
  }
}