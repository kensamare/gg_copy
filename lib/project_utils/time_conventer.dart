String getTime(int t) {
  var diffDt =
      DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(t * 1000));
  var s = diffDt.inSeconds;
  var min = diffDt.inMinutes;
  var h = diffDt.inHours;
  var d = diffDt.inDays;
  var m = diffDt.inDays ~/ 30;
  var y = diffDt.inDays ~/ 365;

  if (y > 0) {
    if (y > 4) {
      return "$d лет";
    }
    if (y > 1) {
      return "$d года";
    }
    return "$y год";
  }
  if (m > 0) {
    return "$m мес.";
  }
  if (d > 0) {
    if (d > 4) {
      return "$d дней";
    }
    if (d > 1) {
      return "$d дня";
    }
    return "$d день";
  }
  if (h > 0) {
    return "$h ч.";
  }
  if (min > 0) {
    return "$min мин";
  }
  if (s > 0) {
    return "$s сек";
  }
  {
    return 'сейчас';
  }
}
