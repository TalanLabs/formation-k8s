import React, {useEffect, useState} from "react";
import ReactDOM from "react-dom";
import axios from "axios";

function App() {
    const [flag, setFlag]=useState('');
    useEffect(()=>{
        window.__ENV__.BACK_URL &&
        axios.get(window.__ENV__.BACK_URL+"/flag").then(res => setFlag(res.data.flag))
            .catch(()=>setFlag("Unknown flag"))
    }, [])
    return <p>{flag}</p>;
}

ReactDOM.render(<App />, document.getElementById("root"));
