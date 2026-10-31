import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_detail_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_summary_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/send_message_result_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/params/send_image_params.dart';
import 'package:fridgy/feature/fridge_ai/domain/params/send_message_params.dart';

abstract class FridgeAiRepo {
  Future<Either<ServerFailure, SendMessageResultEntity>> sendMessage(
    SendMessageParams params,
  );

  Future<Either<ServerFailure, SendMessageResultEntity>> sendImage(
    SendImageParams params,
  );

  Future<Either<ServerFailure, PaginatedList<ConversationSummaryEntity>>>
      getConversations({int page = 1, int limit = 20});

  Future<Either<ServerFailure, ConversationDetailEntity>>
      getConversationMessages(String conversationId);
}
