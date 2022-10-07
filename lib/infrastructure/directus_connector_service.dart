import 'dart:developer';

import 'package:astralnote_app/domain/directus/dto/get_many_directus_items_dto.dart';
import 'package:astralnote_app/domain/directus/dto/get_one_directus_item_dto.dart';
import 'package:astralnote_app/env.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

enum DirectusError { tokenExpired, forbidden, notFound, unexpected, failedValidation }

enum DirectusEndpoint { auth, roles, items, users }

class DirectusConnectorService {
  DirectusConnectorService({
    required Dio dio,
    required DirectusEndpoint endpoint,
  })  : _dio = dio,
        _endpoint = endpoint.name;

  final Dio _dio;
  final String _endpoint;

  factory DirectusConnectorService.auth() {
    return DirectusConnectorService(
      dio: Dio(BaseOptions(baseUrl: Environment().config.backendUrl)),
      endpoint: DirectusEndpoint.auth,
    );
  }

  Future<Either<DirectusError, dynamic>> getOne({required String collection, String? itemId, String? query}) async {
    try {
      final response = await _dio.get(
        '/$_endpoint/$collection/${itemId != null ? '/$itemId' : ''}${query != null ? '?$query' : ''}',
      );
      final responseDTO = GetOneDirectusItemDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  Future<Either<DirectusError, List<dynamic>>> getMany({required String collection}) async {
    try {
      final response = await _dio.get('/$_endpoint/$collection');
      final responseDTO = GetManyDirectusItemsDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  Future<Either<DirectusError, dynamic>> post({required String collection, required dynamic body}) async {
    try {
      final response = await _dio.post('/$_endpoint/$collection', data: body);
      if (response.statusCode == 204) return right(const GetOneDirectusItemDTO(data: ""));
      final responseDTO = GetOneDirectusItemDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  Future<Either<DirectusError, dynamic>> patch({
    required String collection,
    required dynamic body,
    String id = '',
  }) async {
    try {
      final response = await _dio.patch('/$_endpoint/$collection/$id', data: body);
      final responseDTO = GetOneDirectusItemDTO.fromJson(response.data);
      return right(responseDTO.data);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  Future<Either<DirectusError, Unit>> delete({required String collection, required String id}) async {
    try {
      await _dio.delete('/$_endpoint/$collection/$id');
      return right(unit);
    } catch (responseError) {
      return left(_parseResponseError(responseError));
    }
  }

  // Generic error parser for Directus
  DirectusError _parseResponseError(responseError) {
    DirectusError error = DirectusError.unexpected;
    log(responseError.toString());
    if (responseError is DioError && responseError.response?.statusCode == 400) error = DirectusError.failedValidation;
    if (responseError is DioError && responseError.response?.statusCode == 401) error = DirectusError.tokenExpired;
    if (responseError is DioError && responseError.response?.statusCode == 403) error = DirectusError.forbidden;
    return error;
  }
}
