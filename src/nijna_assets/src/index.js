import { AuthClient } from "@dfinity/auth-client";
import { nijna } from "../../declarations/nijna_assets";
import { trader } from "../../declarations/trader";
import { canisterId, createActor } from "../../declarations/whoami";

const init = async () => {
    const authClient = await AuthClient.create();
    if (await authClient.isAuthenticated()) {
      handleAuthenticated(authClient);
    }
    // renderIndex();
  
    const loginButton = document.getElementById("signInButton");
  
    const days = BigInt(1);
    const hours = BigInt(24);
    const nanoseconds = BigInt(3600000000000);
  
    loginButton.onclick = async () => {
      await authClient.login({
        onSuccess: async () => {
          handleAuthenticated(authClient);
        },
        identityProvider:
          process.env.DFX_NETWORK === "ic"
            ? "https://identity.ic0.app/#authorize"
            : "http://127.0.0.1:8000/?canisterId=rdmx6-jaaaa-aaaaa-aaadq-cai",
        // Maximum authorization expiration is 8 days
        maxTimeToLive: days * hours * nanoseconds,
      });
    };
  };
  
  async function handleAuthenticated(authClient) {
    const identity = await authClient.getIdentity();
    const whoami_actor = createActor(canisterId, {
      agentOptions: {
        identity,
      },
    });
  
    // renderLoggedIn(whoami_actor, authClient);
  }
  
  init();