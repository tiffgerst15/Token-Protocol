import { Token } from "../Main";
import React, { useState } from "react";
// import { WalletBalance } from "./WalletBalance";
// import { StakeForm } from "./StakeForm";
import styles from "./wallet.module.scss";
interface WalletProps {
  supportedTokens: Array<Token>;
}
export const Wallet = ({ supportedTokens }: WalletProps) => {
  const [selectedTokenIndex, setSelectedTokenIndex] = useState<number>(0);

  const handleChange = (event: React.ChangeEvent<{}>, newValue: string) => {
    setSelectedTokenIndex(parseInt(newValue));
  };
  return <div>The supported Tokens:</div>;
};
