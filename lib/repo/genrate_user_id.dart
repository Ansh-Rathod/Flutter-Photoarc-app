genrateId(String id) {
  return id.replaceAll(RegExp(r'[0-9]'), "").toLowerCase();
}
