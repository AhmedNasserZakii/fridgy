class MockResponse {
  const MockResponse({required this.assetPath, this.statusCode = 200});

  final String assetPath;
  final int statusCode;
}
