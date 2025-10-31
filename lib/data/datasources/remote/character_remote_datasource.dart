import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/character_model.dart';

class CharacterRemoteDataSource {
  final Dio _dio;

  CharacterRemoteDataSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<List<CharacterModel>> getCharacters({required int page}) async {
    try {
      final response = await _dio.get(
        ApiConstants.characters,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => CharacterModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Failed to load characters',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else {
        throw Exception('Failed to load characters: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
