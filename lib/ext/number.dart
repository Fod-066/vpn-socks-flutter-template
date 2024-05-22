extension IntExt on int {
  String formatDuration() {
    var seconds = this;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  String formatBytes() {
    if (this < 1024) {
      return '$this B';
    } else if (this < 1024 * 1024) {
      double kilobytes = this / 1024;
      return '${kilobytes.toStringAsFixed(2)} KB';
    } else {
      double megabytes = this / (1024 * 1024);
      return '${megabytes.toStringAsFixed(2)} MB';
    }
  }
}
