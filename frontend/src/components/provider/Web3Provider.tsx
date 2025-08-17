import { WagmiProvider, createConfig, http } from "wagmi";
import { baseSepolia, sepolia } from "wagmi/chains";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ConnectKitProvider, getDefaultConfig } from "connectkit";
import type React from "react";

const config = createConfig(
  getDefaultConfig({
    chains: [sepolia, baseSepolia],
    transports: {
      [sepolia.id]: http(),
    },

    walletConnectProjectId: "",
    appName: "",
    appDescription: "",
    appUrl: "",
    appIcon: "",
  })
);

const queryClient = new QueryClient();

export const Provider = ({ children }: { children: React.ReactNode }) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <ConnectKitProvider>{children}</ConnectKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
};
