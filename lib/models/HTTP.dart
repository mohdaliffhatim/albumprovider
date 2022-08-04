class ResponseHTTP<T> {
  bool isSuccessful;
  T data;
  int codeStatus;
  String message;
  ResponseHTTP(this.isSuccessful, this.data, {this.message, this.codeStatus});
}