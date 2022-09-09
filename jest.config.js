module.exports = {
    collectCoverage: true,
    // We want to exclude helper functions in __tests__ from code coverage collection.
    collectCoverageFrom: [
        "lib/js/src/*"
    ],
    coveragePathIgnorePatterns: [
        // Even though all the tests refer to ConstrainedType, and not the ConstrainedType_* files
        // the rescript compiler optimizes away the reference to ConstrainedType. This means that the code
        // in ConstrainedType itself is never run.
        "src\/ConstrainedType.mjs$"
    ],
    coverageThreshold: {
        global: {
            branches: 100,
            functions: 100,
            lines: 100,
            statements: 100
        }
    },
    moduleFileExtensions: [
        "js",
        "mjs",
    ],
    setupFiles: ["./jest.setup.js"],
    testMatch: [
        "**/__tests__/**/*_test.mjs",
    ],
    transform: {
        "^.+\.m?js$": "babel-jest"
    }
}