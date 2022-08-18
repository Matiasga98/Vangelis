import '../util/enums.dart';

class AbnormalOperationNotification {
  final MessageType type;
  final String message;

  AbnormalOperationNotification({required this.type, required this.message});
}
