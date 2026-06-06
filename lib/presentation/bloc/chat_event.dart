import 'package:equatable/equatable.dart';
import '../../domain/entities/time_preset.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendUserMessage extends ChatEvent {
  final String text;
  final TimePreset timePreset;

  const SendUserMessage(this.text, this.timePreset);

  @override
  List<Object?> get props => [text, timePreset];
}

class CancelReflection extends ChatEvent {
  const CancelReflection();
}
