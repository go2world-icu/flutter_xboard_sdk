import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_notice_models.dart';

/// V2Board 公告 API 实现
class V2BoardNoticeApi {
  final HttpService _httpService;

  V2BoardNoticeApi(this._httpService);

  Future<ApiResponse<List<Notice>>> fetchNotices() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/notice/fetch');
      
      // API 返回的 data 可能是 Map (包含 data 数组和 total) 或直接是 List
      final dynamic dataField = result['data'];
      
      List<Notice> notices;
      if (dataField is List) {
        // 如果 data 直接是数组
        notices = dataField
            .map((e) => Notice.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (dataField is Map<String, dynamic>) {
        // 如果 data 是包含 data 数组的对象
        final noticeData = dataField['data'] as List<dynamic>? ?? [];
        notices = noticeData
            .map((e) => Notice.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        notices = [];
      }
      
      return ApiResponse(
        success: true,
        data: notices,
        message: result['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取公告列表失败: $e');
    }
  }
}
