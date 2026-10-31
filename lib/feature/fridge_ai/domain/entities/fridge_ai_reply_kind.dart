enum FridgeAiReplyKind {
  text,
  clarification,
  proposal;

  static FridgeAiReplyKind fromApi(String? value) {
    switch (value) {
      case 'clarification':
        return FridgeAiReplyKind.clarification;
      case 'proposal':
        return FridgeAiReplyKind.proposal;
      case 'text':
      default:
        return FridgeAiReplyKind.text;
    }
  }

  String toApi() {
    switch (this) {
      case FridgeAiReplyKind.text:
        return 'text';
      case FridgeAiReplyKind.clarification:
        return 'clarification';
      case FridgeAiReplyKind.proposal:
        return 'proposal';
    }
  }
}
