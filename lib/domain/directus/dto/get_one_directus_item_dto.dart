import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_one_directus_item_dto.freezed.dart';
part 'get_one_directus_item_dto.g.dart';

@freezed
class GetOneDirectusItemDTO with _$GetOneDirectusItemDTO {
  const factory GetOneDirectusItemDTO({
    required dynamic data,
  }) = _GetOneDirectusItemDTO;

  const GetOneDirectusItemDTO._();

  factory GetOneDirectusItemDTO.fromJson(Map<String, dynamic> json) => _$GetOneDirectusItemDTOFromJson(json);
}
