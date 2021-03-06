import NimQml
import tables
import ../../../status/wallet

type
  AssetRoles {.pure.} = enum
    Name = UserRole + 1,
    Symbol = UserRole + 2,
    Value = UserRole + 3,
    FiatValue = UserRole + 4

QtObject:
  type AssetList* = ref object of QAbstractListModel
    assets*: seq[Asset]

  proc setup(self: AssetList) = self.QAbstractListModel.setup

  proc delete(self: AssetList) =
    self.QAbstractListModel.delete
    self.assets = @[]

  proc newAssetList*(): AssetList =
    new(result, delete)
    result.assets = @[]
    result.setup

  method rowCount(self: AssetList, index: QModelIndex = nil): int =
    return self.assets.len

  method data(self: AssetList, index: QModelIndex, role: int): QVariant =
    if not index.isValid:
      return
    if index.row < 0 or index.row >= self.assets.len:
      return
    let asset = self.assets[index.row]
    let assetRole = role.AssetRoles
    case assetRole:
    of AssetRoles.Name: result = newQVariant(asset.name)
    of AssetRoles.Symbol: result = newQVariant(asset.symbol)
    of AssetRoles.Value: result = newQVariant(asset.value)
    of AssetRoles.FiatValue: result = newQVariant(asset.fiatValue)

  method roleNames(self: AssetList): Table[int, string] =
    { AssetRoles.Name.int:"name",
    AssetRoles.Symbol.int:"symbol",
    AssetRoles.Value.int:"value",
    AssetRoles.FiatValue.int:"fiatValue" }.toTable

  proc addAssetToList*(self: AssetList, asset: Asset) =
    self.beginInsertRows(newQModelIndex(), self.assets.len, self.assets.len)
    self.assets.add(asset)
    self.endInsertRows()

  proc setNewData*(self: AssetList, assetList: seq[Asset]) =
    self.beginResetModel()
    self.assets = assetList
    self.endResetModel()

  proc forceUpdate*(self: AssetList) =
    self.beginResetModel()
    self.endResetModel()
