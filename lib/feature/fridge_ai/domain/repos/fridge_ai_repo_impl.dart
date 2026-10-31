import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/connection/network_info.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/print_debug.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/api_service.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_model.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/feature/fridge_ai/data/models/conversation_detail_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/conversation_summary_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/send_message_result_model.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_detail_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_summary_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/send_message_result_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/params/send_image_params.dart';
import 'package:fridgy/feature/fridge_ai/domain/params/send_message_params.dart';
import 'package:fridgy/feature/fridge_ai/domain/repos/fridge_ai_repo.dart';

class FridgeAiRepoImpl implements FridgeAiRepo {
  FridgeAiRepoImpl({required this._apiService, required this._networkInfo});

  final ApiService _apiService;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<ServerFailure, SendMessageResultEntity>> sendMessage(
    SendMessageParams params,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.post(
        WebConstant.fridgeAiMessages,
        requireAuth: true,
        data: {
          ApiKeys.mode: params.mode.toApi(),
          ApiKeys.message: params.message,
          ApiKeys.conversationId: params.conversationId,
        },
      );
      return _parseSendResult(response.data);
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai sendMessage dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai sendMessage catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, SendMessageResultEntity>> sendImage(
    SendImageParams params,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final form = FormData.fromMap({
        ApiKeys.mode: params.mode.toApi(),
        ApiKeys.conversationId: params.conversationId,
        if (params.message != null && params.message!.trim().isNotEmpty)
          ApiKeys.message: params.message!.trim(),
        ApiKeys.image: await MultipartFile.fromFile(
          params.imagePath,
          filename: params.fileName ?? 'fridge_ai_image.jpg',
        ),
      });

      final response = await _apiService.postMultipart(
        WebConstant.fridgeAiMessagesImage,
        data: form,
        requireAuth: true,
      );
      return _parseSendResult(response.data);
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai sendImage dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai sendImage catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Either<ServerFailure, SendMessageResultEntity> _parseSendResult(
    Object? body,
  ) {
    if (body is! Map<String, dynamic>) {
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
    final data = body[ApiKeys.data];
    if (data is! Map<String, dynamic>) {
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
    return Right(SendMessageResultModel.fromJson(data).toEntity());
  }

  @override
  Future<Either<ServerFailure, PaginatedList<ConversationSummaryEntity>>>
      getConversations({int page = 1, int limit = 20}) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.fridgeAiConversations,
        requireAuth: true,
        queryParameters: {ApiKeys.page: page, ApiKeys.limit: limit},
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      final data = body[ApiKeys.data];
      final meta = body[ApiKeys.meta];
      if (data is! List || meta is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      final items = data
          .whereType<Map>()
          .map(
            (e) =>
                ConversationSummaryModel.fromJson(Map<String, dynamic>.from(e))
                    .toEntity(),
          )
          .toList();

      return Right(
        PaginatedList(
          items: items,
          meta: PaginationMetaModel.fromJson(meta).toEntity(),
        ),
      );
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai getConversations dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai getConversations catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, ConversationDetailEntity>>
      getConversationMessages(String conversationId) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.fridgeAiConversationMessages(conversationId),
        requireAuth: true,
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      return Right(ConversationDetailModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai getConversationMessages dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai getConversationMessages catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }
}
