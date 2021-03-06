import tables, strformat, strutils, stint, httpclient, json
import ../libstatus/wallet as status_wallet
import ../libstatus/tokens as status_tokens
import account

type BalanceManager* = ref object
  pricePairs: Table[string, string]
  tokenBalances: Table[string, string]

proc newBalanceManager*(): BalanceManager =
  result = BalanceManager()
  result.pricePairs = initTable[string, string]()
  result.tokenBalances = initTable[string, string]()

var balanceManager = newBalanceManager()

proc getPrice(crypto: string, fiat: string): string =
  try:
    if balanceManager.pricePairs.hasKey(fiat):
      return balanceManager.pricePairs[fiat]
    let url: string = fmt"https://min-api.cryptocompare.com/data/price?fsym={crypto}&tsyms={fiat}"
    let client = newHttpClient()
    client.headers = newHttpHeaders({ "Content-Type": "application/json" })

    let response = client.request(url)
    result = $parseJson(response.body)[fiat.toUpper]
    # balanceManager.pricePairs[fiat] = result
  except Exception as e:
    echo "error getting price"
    echo e.msg
    result = "0.0"

proc getEthBalance(address: string): string =
  var balance = status_wallet.getBalance(address)
  result = status_wallet.hex2Eth(balance)
#   balanceManager.tokenBalances["ETH"] = result

proc getBalance*(symbol: string, accountAddress: string, tokenAddress: string): string =
  if balanceManager.tokenBalances.hasKey(symbol):
    return balanceManager.tokenBalances[symbol]

  if symbol == "ETH":
    return getEthBalance(accountAddress)
  result = $status_tokens.getTokenBalance(tokenAddress, accountAddress)
#   balanceManager.tokenBalances[symbol] = result

proc getFiatValue*(crypto_balance: string, crypto_symbol: string, fiat_symbol: string): float =
  if crypto_balance == "0.0": return 0.0
  var fiat_crypto_price = getPrice(crypto_symbol, fiat_symbol)
  parseFloat(crypto_balance) * parseFloat(fiat_crypto_price)

proc updateBalance*(asset: Asset, currency: string) =
  var token_balance = getBalance(asset.symbol, asset.accountAddress, asset.address)
  let fiat_balance = getFiatValue(token_balance, asset.symbol, currency)
  asset.value = token_balance
  asset.fiatValue = fmt"{fiat_balance:.2f} {currency}"

proc updateBalance*(account: WalletAccount, currency: string) =
  let eth_balance = getBalance("ETH", account.address, "")
  let usd_balance = getFiatValue(eth_balance, "ETH", currency)
  var totalAccountBalance = usd_balance
  account.realFiatBalance = totalAccountBalance
  account.balance = fmt"{totalAccountBalance:.2f} {currency}"
  for asset in account.assetList:
    updateBalance(asset, currency)
