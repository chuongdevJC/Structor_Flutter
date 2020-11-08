import 'base_request.dart';

class GetUsersRequest extends BaseRequest {
  final String keyword;
  final int page;
  final int limit;

  GetUsersRequest(this.keyword, {this.page, this.limit});

  @override
  List<Object> get props => [url, keyword, page, limit];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'q': keyword, 'page': page, 'per_page': limit};
  }

  @override
  String get url => "/search/users";
}
