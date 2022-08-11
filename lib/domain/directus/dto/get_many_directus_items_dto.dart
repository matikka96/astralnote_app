import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_many_directus_items_dto.g.dart';
part 'get_many_directus_items_dto.freezed.dart';

@freezed
class GetManyDirectusItemsDTO with _$GetManyDirectusItemsDTO {
  const factory GetManyDirectusItemsDTO({
    required List<dynamic> data,
  }) = _GetManyDirectusItemsDTO;

  const GetManyDirectusItemsDTO._();

  factory GetManyDirectusItemsDTO.fromJson(Map<String, dynamic> json) => _$GetManyDirectusItemsDTOFromJson(json);
}
