import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/models/chat_model.dart';

part 'chat_widget.controller.state.freezed.dart';

@freezed

/// Chat Widget Controller State
class ChatWidgetControllerState with _$ChatWidgetControllerState {
  /// State Construction
  factory ChatWidgetControllerState({
    @Default(AsyncData([])) AsyncValue<List<ChatModel>> messages,
    @Default('') String messageCreatedEvent,
  }) = _ChatWidgetControllerState;
}
