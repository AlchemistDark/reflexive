import 'package:equatable/equatable.dart';
import 'package:reflexive/domain/entities/time_preset.dart';

/// Base class for all events in the [ChatBloc].
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the user sends a message.
class SendUserMessage extends ChatEvent {
  /// The text content of the user's query.
  final String text;

  const SendUserMessage(this.text);

  @override
  List<Object?> get props => [text];
}

/// Event triggered to cancel the ongoing reflection process.
class CancelReflection extends ChatEvent {
  const CancelReflection();
}
