# Polaris

Polaris is copy trading platform that tries to bring the trust in traders for investors.

Project is made out of 3 canisters.

### Trader
*Trader* is a user who has a possibility of investing funds of third parties called *Investors*

### Investor
*Investor* is a user who has a possibility of following *Traders* and investing in positions suggested by those *Traders*

### Position
*Position* is an object that stores information about investment suggested by a *trader* (spot price, target price, stop loss price, exchange, pair, metadata, etc.)


## Running the project locally

If you want to test your project locally, you can use the following commands:

```bash
# Starts the replica, running in the background
dfx start --background

# Deploys your canisters to the replica and generates your candid interface
dfx deploy
```

Additionally, if you are making frontend changes, you can start a development server with

```bash
npm start
```

Which will start a server at `http://localhost:8080`, proxying API requests to the replica at port 8000.


## Helpful links

- [Quick Start](https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html)
- [SDK Developer Tools](https://sdk.dfinity.org/docs/developers-guide/sdk-guide.html)
- [Motoko Programming Language Guide](https://sdk.dfinity.org/docs/language-guide/motoko.html)
- [Motoko Language Quick Reference](https://sdk.dfinity.org/docs/language-guide/language-manual.html)
- [JavaScript API Reference](https://erxue-5aaaa-aaaab-qaagq-cai.raw.ic0.app)

## TODO
- add unittests
- change Array.append to Buffer.append
- move some functions from `main.mo` of each canister to `utils.mo`