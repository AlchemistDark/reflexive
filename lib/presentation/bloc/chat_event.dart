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

  /// The time preset selected for the reflection process.
  final TimePreset timePreset;

  const SendUserMessage(this.text, this.timePreset);

  @override
  List<Object?> get props => [text, timePreset];
}

/// Event triggered to cancel the ongoing reflection process.
class CancelReflection extends ChatEvent {
  const CancelReflection();
}
