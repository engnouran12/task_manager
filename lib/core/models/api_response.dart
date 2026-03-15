class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final Pagination? pagination;

  ApiResponse({
    required this.success,
    this.data,
    this.message = '',
    this.pagination,
  });

  factory ApiResponse.success(T data, {String message = '', Pagination? pagination}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      pagination: pagination,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(
      success: false,
      message: message,
    );
  }
}

class Pagination {
  final int totalCount;
  final int pageSize;
  final int currentPage;
  final int totalPages;

  Pagination({
    required this.totalCount,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
  });
}
