import Navbar from "./components/Navbar";
import styles from "./app.module.scss";
import Particles from "react-particles";
import { loadFull } from "tsparticles";
import { useCallback } from "react";
import { Main } from "./components/Main";
import logo from "./img/logo1.svg";

function App() {
  return (
    <div className={styles.App}>
      <div className={styles.Navbar}>
        <Navbar />
      </div>
      <div className={styles.body}>
        {/* <img src={logo} className={styles.logo}></img> */}
        <Main />
      </div>
    </div>
  );
}

export default App;
