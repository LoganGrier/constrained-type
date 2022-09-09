const fc = require("fast-check");
// Since our runs are very fast, the tradeoff between defect-rates and 
// test-time favors doing many runs
fc.configureGlobal({ numRuns: 10000 });