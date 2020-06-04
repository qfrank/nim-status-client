import eventemitter

import libstatus/types
import libstatus/accounts as libstatus_accounts
import libstatus/core as libstatus_core

import chat as chat
import accounts as accounts
import wallet as wallet
import node as node
import mailservers as mailservers

type Status* = ref object
  events*: EventEmitter
  chat*: ChatModel
  mailservers*: MailserverModel
  accounts*: AccountModel
  wallet*: WalletModel
  node*: NodeModel

proc newStatusInstance*(): Status =
  result = Status()
  result.events = createEventEmitter()
  result.chat = chat.newChatModel(result.events)
  result.accounts = accounts.newAccountModel(result.events)
  result.wallet = wallet.newWalletModel(result.events)
  result.wallet.initEvents()
  result.node = node.newNodeModel()
  result.mailservers = mailservers.newMailserverModel(result.events)

proc on*(self: Status, eventName: string, handler: Handler): void =
  self.events.on(eventName, handler)

proc once*(self: Status, eventName: string, handler: Handler): void =
  self.events.once(eventName, handler)

proc emit*(self: Status, eventName: string, args: Args): void =
  echo "forbidden: cannot emit an event externaly; please consult documentation"
  raise newException(Exception, "forbidden: cannot emit an event externaly")

proc initNodeAccounts*(self: Status): seq[NodeAccount] = 
  libstatus_accounts.initNodeAccounts()

proc startMessenger*(self: Status) =
  libstatus_core.startMessenger()
