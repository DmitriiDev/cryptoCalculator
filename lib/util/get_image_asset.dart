String getFlagImageAssetPath(String assetSymbol) {
  var updatedName = assetSymbol;
  if (updatedName.toLowerCase().contains('usdt')) {
    updatedName = updatedName.substring(0, updatedName.length - 4);
  }

  if (updatedName.toLowerCase().contains('usd')) {
    updatedName = updatedName.substring(0, updatedName.length - 3);
  }

  return "assets/${updatedName.toLowerCase()}.png";
}
