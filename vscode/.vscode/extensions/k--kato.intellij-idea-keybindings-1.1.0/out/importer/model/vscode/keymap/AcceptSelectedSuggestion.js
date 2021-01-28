"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Rename = void 0;
const VSCodeKeyDefault_1 = require("../VSCodeKeyDefault");
class Rename {
    constructor() {
        this.command = "acceptSelectedSuggestion";
        this.when = "suggestWidgetVisible && textInputFocus";
        this.keysDefault = [
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", "tab"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", "tab"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", "tab"),
        ];
    }
}
exports.Rename = Rename;
/*
{
  "key": "tab",
  "command": "acceptSelectedSuggestion",
  "when": "suggestWidgetVisible && textInputFocus"
}
{
  "key": "enter",
  "command": "acceptSelectedSuggestion",
  "when": "acceptSuggestionOnEnter && suggestWidgetVisible && suggestionMakesTextEdit && textInputFocus"
}
*/
//# sourceMappingURL=AcceptSelectedSuggestion.js.map