import { useEthers } from "@usedapp/core";
import networkMapping from "../chain-info/deployments/map.json";
import { constants } from "ethers";
// import brownieConfig from "../brownie-config.json";
import dai from "../img/dai.png";
import eth from "../img/eth.png";
import aave from "../img/aave.png";
import { Wallet } from "./wallet";
import styles from "./main.module.scss";
import { useState } from "react";

export type Token = {
  image: string;
  address: string;
  name: string;
};

export const Main = () => {
  //   // Show token values from the wallet
  //   // Get the address of different tokens
  //   // Get the balance of the users wallet

  // send the brownie-config to our `src` folder
  // send the build folder
  const { chainId } = useEthers();
  console.log(chainId);

  const trsyToken =
    chainId == 5 ? networkMapping["5"]["TRSYERC20"][0] : constants.AddressZero;
  const daiToken =
    chainId == 5 ? networkMapping["5"]["MockERC20"][2] : constants.AddressZero;
  const aaveToken =
    chainId == 5 ? networkMapping["5"]["MockERC20"][1] : constants.AddressZero;
  const ethToken =
    chainId == 5 ? networkMapping["5"]["MockERC20"][0] : constants.AddressZero;

  const supportedTokens: Array<Token> = [
    {
      image: dai,
      address: daiToken,
      name: "DAI",
    },
    {
      image: aave,
      address: aaveToken,
      name: "AAVE",
    },
    {
      image: eth,
      address: ethToken,
      name: "ETH",
    },
    {
      image: eth,
      address: constants.AddressZero,
      name: "ETH",
    },
  ];

  return (
    <div>
      <h2>Our Tokens</h2>
      <Wallet supportedTokens={supportedTokens} />
    </div>
  );
};
