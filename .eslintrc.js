module.exports = {
    "env": {
        "browser": true,
        "es2021": true
    },
    "extends": "standard",
    "ignorePatterns": [".eslintrc.js", "vendor/**/*", "node_modules/**/*"],
    "overrides": [
        {
          "files": ["*.ts", "*.tsx"],
          "extends": [
            "plugin:@typescript-eslint/eslint-recommended",
            "plugin:@typescript-eslint/recommended"
          ],
          "parser": "@typescript-eslint/parser",
          "plugins": ["@typescript-eslint"]
        }
      ],
    "parserOptions": {
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "rules": {
    }
}
