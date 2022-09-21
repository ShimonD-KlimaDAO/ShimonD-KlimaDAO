# KlimaDAO Live Event Offsetting

## Idea
Live offsetting is a great marketing tool for events, allowing people to experience offsetting in real time without any obstacles. The offsets, gas, and everything web3 related is prepaid and done by us - the user just submits a love letter and a name.

The idea is to have a frontend page that controls private keys to a wallet with some gas, and calls a contract function. The contract calls the aggregator, but it’s also configurable for each event, deciding how much to offset per love letter, which project to use, beneficiary details, etc.

## Version 1 Notes
* Normal and selective retirements are both supported.
* Only "offsetter" can call this function, and only I ("owner") can change the offsetter, withdraw funds from the contract, and change "event parameters" for live offsetting events.
* Offsetter is based on Ownable, but can be changed only by "owner" from Ownable.
