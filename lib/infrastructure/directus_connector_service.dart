import 'package:astralnote_app/config.dart';
import 'package:astralnote_app/domain/directus/dto/get_many_directus_items_dto.dart';
import 'package:astralnote_app/domain/directus/dto/get_one_directus_item_dto.dart';
import 'package:astralnote_app/domain/generic_error.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

enum DirectusEndpoins { auth, roles, items, users }

class DirectusConnectorService {
  DirectusConnectorService({
    required Dio dio,
    required DirectusEndpoins endpoint,
  })  : _dio = dio,
        _endpoint = endpoint.name;

  final Dio _dio;
  final String _endpoint;

  factory DirectusConnectorService.auth() {
    return DirectusConnectorService(dio: Dio(BaseOptions(baseUrl: Config.backendUrl)), endpoint: DirectusEndpoins.auth);
  }

  Future<Either<GenericError, dynamic>> getOne({required String collection, required String itemId}) async {
    try {
      final response = await _dio.get('/$_endpoint/$collection/$itemId');
      final responseDTO = GetOneDirectusItemDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  Future<Either<GenericError, List<dynamic>>> getMany({required String collection}) async {
    try {
      final response = await _dio.get('/$_endpoint/$collection');
      final responseDTO = GetManyDirectusItemsDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  Future<Either<GenericError, dynamic>> post({required String collection, required dynamic body}) async {
    try {
      final response = await _dio.post('/$_endpoint/$collection', data: body);
      if (response.statusCode == 204) return right(const GetOneDirectusItemDTO(data: ""));
      final responseDTO = GetOneDirectusItemDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  Future<Either<GenericError, dynamic>> patch({
    required String collection,
    required String id,
    required dynamic body,
  }) async {
    try {
      final response = await _dio.patch('/$_endpoint/$collection/$id', data: body);
      final responseDTO = GetOneDirectusItemDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  // Generic error parser for Directus
  GenericError _parseResponseError(responseError) {
    GenericError error = GenericError.unexpected;
    if (responseError is DioError && responseError.response?.statusCode == 400) error = GenericError.failedValidation;
    if (responseError is DioError && responseError.response?.statusCode == 401) error = GenericError.tokenExpired;
    if (responseError is DioError && responseError.response?.statusCode == 403) error = GenericError.forbidden;
    return error;
  }
}
