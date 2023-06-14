const express = require("express");
const os = require("os");
const fs = require('fs');
const cors = require('cors');
const morgan = require('morgan');

// Constants
const PORT = process.env.PORT || 8080;
const HOST = process.env.HOST || "0.0.0.0";

// App
const app = express();
console.log("starting app");

app.use(cors());
app.use(morgan('combined'));

app.get("/", (req, res) => {
    const infos = {
        path: req.path,
        headers: req.headers,
        method: req.method,
        body: req.body,
        cookies: req.cookies,
        fresh: req.fresh,
        hostname: req.hostname,
        ip: req.ip,
        ips: req.ips,
        protocol: req.protocol,
        query: req.query,
        subdomains: req.subdomains,
        xhr: req.xhr,
        os: {
            hostname: os.hostname(),
        },
    };
    res.json(infos);
});

app.get("/api/flag", (req, res) => {
    let flag;
    if (process.env.FLAG) {
        flag = process.env.FLAG;
    }

    const bddPath = process.env.BDD_PATH;
    if (bddPath) {
        flag = JSON.parse(fs.readFileSync(bddPath, {encoding: 'utf-8'})).flag;
    }

    if (flag) {
        res.json({flag});
    } else if (bddPath) {
        throw new Error("Couldn't open database at " + bddPath);
    } else {
        throw new Error("No flag");
    }
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
